#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <lib/term.h>
#include <lib/real.h>
#include <lib/misc.h>
#include <mm/pmm.h>
#include <drivers/vga_textmode.h>
#include <term/backends/framebuffer.h>

int current_video_mode = -1;
int term_backend = _NOT_READY;

struct term_context *term;

static struct term_context term_local_struct;

// --- notready ---

static void notready_raw_putchar(struct term_context *ctx, uint8_t c) {
    (void)ctx;
    (void)c;
}
static void notready_clear(struct term_context *ctx, bool move) {
    (void)ctx;
    (void)move;
}
static void notready_void(struct term_context *ctx) {
    (void)ctx;
}
static void notready_set_cursor_pos(struct term_context *ctx, size_t x, size_t y) {
    (void)ctx;
    (void)x; (void)y;
}
static void notready_get_cursor_pos(struct term_context *ctx, size_t *x, size_t *y) {
    (void)ctx;
    *x = 0;
    *y = 0;
}
static void notready_size_t(struct term_context *ctx, size_t n) {
    (void)ctx;
    (void)n;
}
static bool notready_disable(struct term_context *ctx) {
    (void)ctx;
    return false;
}
static void notready_move_character(struct term_context *ctx, size_t a, size_t b, size_t c, size_t d) {
    (void)ctx;
    (void)a; (void)b; (void)c; (void)d;
}
static void notready_uint32_t(struct term_context *ctx, uint32_t n) {
    (void)ctx;
    (void)n;
}
static void notready_deinit(struct term_context *ctx, void (*_free)(void *, size_t)) {
    (void)ctx;
    (void)_free;
}

static void term_notready(void) {
    if (term != NULL) {
        term->deinit(term, pmm_free);
        term = NULL;
    }

    term = &term_local_struct;

    term->raw_putchar = notready_raw_putchar;
    term->clear = notready_clear;
    term->enable_cursor = notready_void;
    term->disable_cursor = notready_disable;
    term->set_cursor_pos = notready_set_cursor_pos;
    term->get_cursor_pos = notready_get_cursor_pos;
    term->set_text_fg = notready_size_t;
    term->set_text_bg = notready_size_t;
    term->set_text_fg_bright = notready_size_t;
    term->set_text_bg_bright = notready_size_t;
    term->set_text_fg_rgb = notready_uint32_t;
    term->set_text_bg_rgb = notready_uint32_t;
    term->set_text_fg_default = notready_void;
    term->set_text_bg_default = notready_void;
    term->move_character = notready_move_character;
    term->scroll = notready_void;
    term->revscroll = notready_void;
    term->swap_palette = notready_void;
    term->save_state = notready_void;
    term->restore_state = notready_void;
    term->double_buffer_flush = notready_void;
    term->full_refresh = notready_void;
    term->deinit = notready_deinit;

    term->cols = 80;
    term->rows = 24;

    term_backend = _NOT_READY;
    term_context_reinit(term);

    term->in_bootloader = true;
}

// --- fallback ---

#if defined (BIOS)
static void fallback_raw_putchar(struct term_context *ctx, uint8_t c) {
    (void)ctx;
    struct rm_regs r = {0};
    r.eax = 0x0e00 | c;
    rm_int(0x10, &r, &r);
}

static void fallback_set_cursor_pos(struct term_context *ctx, size_t x, size_t y);
static void fallback_get_cursor_pos(struct term_context *ctx, size_t *x, size_t *y);

static void fallback_clear(struct term_context *ctx, bool move) {
    (void)ctx;
    size_t x, y;
    fallback_get_cursor_pos(NULL, &x, &y);
    struct rm_regs r = {0};
    rm_int(0x11, &r, &r);
    switch ((r.eax >> 4) & 3) {
        case 0:
            r.eax = 3;
            break;
        case 1:
            r.eax = 1;
            break;
        case 2:
            r.eax = 3;
            break;
        case 3:
            r.eax = 7;
            break;
    }
    rm_int(0x10, &r, &r);
    if (move) {
        x = y = 0;
    }
    fallback_set_cursor_pos(NULL, x, y);
}

static void fallback_set_cursor_pos(struct term_context *ctx, size_t x, size_t y) {
    (void)ctx;
    struct rm_regs r = {0};
    r.eax = 0x0200;
    r.ebx = 0;
    r.edx = (y << 8) + x;
    rm_int(0x10, &r, &r);
}

static void fallback_get_cursor_pos(struct term_context *ctx, size_t *x, size_t *y) {
    (void)ctx;
    struct rm_regs r = {0};
    r.eax = 0x0300;
    r.ebx = 0;
    rm_int(0x10, &r, &r);
    *x = r.edx & 0xff;
    *y = r.edx >> 8;
}

static void fallback_scroll(struct term_context *ctx) {
    (void)ctx;
    size_t x, y;
    fallback_get_cursor_pos(NULL, &x, &y);
    fallback_set_cursor_pos(NULL, term->cols - 1, term->rows - 1);
    fallback_raw_putchar(NULL, ' ');
    fallback_set_cursor_pos(NULL, x, y);
}

#elif defined (UEFI)

static size_t cursor_x = 0, cursor_y = 0;

static void fallback_scroll(struct term_context *ctx) {
    (void)ctx;
    gST->ConOut->SetCursorPosition(gST->ConOut, term->cols - 1, term->rows - 1);
    CHAR16 string[2];
    string[0] = ' ';
    string[1] = 0;
    gST->ConOut->OutputString(gST->ConOut, string);
    gST->ConOut->SetCursorPosition(gST->ConOut, cursor_x, cursor_y);
}

static void fallback_raw_putchar(struct term_context *ctx, uint8_t c) {
    if (!ctx->scroll_enabled && cursor_x == term->cols - 1 && cursor_y == term->rows - 1) {
        return;
    }
    gST->ConOut->EnableCursor(gST->ConOut, true);
    CHAR16 string[2];
    string[0] = c;
    string[1] = 0;
    gST->ConOut->OutputString(gST->ConOut, string);
    if (++cursor_x >= term->cols) {
        cursor_x = 0;
        if (++cursor_y >= term->rows) {
            cursor_y--;
        }
    }
    gST->ConOut->SetCursorPosition(gST->ConOut, cursor_x, cursor_y);
}

static void fallback_clear(struct term_context *ctx, bool move) {
    (void)ctx;
    gST->ConOut->ClearScreen(gST->ConOut);
    if (move) {
        cursor_x = cursor_y = 0;
    }
    gST->ConOut->SetCursorPosition(gST->ConOut, cursor_x, cursor_y);
}

static void fallback_set_cursor_pos(struct term_context *ctx, size_t x, size_t y) {
    (void)ctx;
    if (x >= term->cols || y >= term->rows) {
        return;
    }
    gST->ConOut->SetCursorPosition(gST->ConOut, x, y);
    cursor_x = x;
    cursor_y = y;
}

static void fallback_get_cursor_pos(struct term_context *ctx, size_t *x, size_t *y) {
    (void)ctx;
    *x = cursor_x;
    *y = cursor_y;
}
#endif

void term_fallback(void) {
    term_notready();

#if defined (UEFI)
    if (!efi_boot_services_exited) {
#endif
        fallback_clear(NULL, true);
        term->raw_putchar = fallback_raw_putchar;
        term->clear = fallback_clear;
        term->set_cursor_pos = fallback_set_cursor_pos;
        term->get_cursor_pos = fallback_get_cursor_pos;
        term->scroll = fallback_scroll;
#if defined (UEFI)
        UINTN uefi_term_x_size, uefi_term_y_size;
        gST->ConOut->QueryMode(gST->ConOut, gST->ConOut->Mode->Mode, &uefi_term_x_size, &uefi_term_y_size);
        term->cols = uefi_term_x_size;
        term->rows = uefi_term_y_size;
#elif defined (BIOS)
        term->cols = 80;
        term->rows = 25;
#endif
        term_backend = FALLBACK;
        term_context_reinit(term);

        term->in_bootloader = true;
#if defined (UEFI)
    }
#endif
}

extern void reset_term(void);
extern void set_cursor_pos_helper(size_t x, size_t y);

#if defined (__i386__)
#define TERM_XFER_CHUNK 8192

static uint8_t xfer_buf[TERM_XFER_CHUNK];
#endif

static uint64_t context_size(void) {
    switch (term_backend) {
#if defined (BIOS)
        case TEXTMODE:
            return sizeof(struct textmode_context) + (VD_ROWS * VD_COLS) * 2;
#endif
        case GTERM: {
            struct fbterm_context *ctx = (void *)term;
            return sizeof(struct fbterm_context) +
                   ctx->font_bits_size +
                   ctx->font_bool_size +
                   ctx->canvas_size +
                   ctx->grid_size +
                   ctx->queue_size +
                   ctx->map_size;
        }
        default:
            return 0;
    }
}

static void context_save(uint64_t buf) {
    switch (term_backend) {
#if defined (BIOS)
        case TEXTMODE: {
            struct textmode_context *ctx = (void *)term;
            memcpy32to64(buf, (uintptr_t)ctx, sizeof(struct textmode_context));
            buf += sizeof(struct textmode_context);
            memcpy32to64(buf, (uintptr_t)ctx->back_buffer, VD_ROWS * VD_COLS);
            buf += VD_ROWS * VD_COLS;
            memcpy32to64(buf, (uintptr_t)ctx->front_buffer, VD_ROWS * VD_COLS);
            buf += VD_ROWS * VD_COLS;
            break;
        }
#endif
        case GTERM: {
            struct fbterm_context *ctx = (void *)term;
            memcpy32to64(buf, (uintptr_t)ctx, sizeof(struct fbterm_context));
            buf += sizeof(struct fbterm_context);
            memcpy32to64(buf, (uintptr_t)ctx->font_bits, ctx->font_bits_size);
            buf += ctx->font_bits_size;
            memcpy32to64(buf, (uintptr_t)ctx->font_bool, ctx->font_bool_size);
            buf += ctx->font_bool_size;
            memcpy32to64(buf, (uintptr_t)ctx->canvas, ctx->canvas_size);
            buf += ctx->canvas_size;
            memcpy32to64(buf, (uintptr_t)ctx->grid, ctx->grid_size);
            buf += ctx->grid_size;
            memcpy32to64(buf, (uintptr_t)ctx->queue, ctx->queue_size);
            buf += ctx->queue_size;
            memcpy32to64(buf, (uintptr_t)ctx->map, ctx->map_size);
            buf += ctx->map_size;
            break;
        }
    }
}

static void context_restore(uint64_t buf) {
    switch (term_backend) {
#if defined (BIOS)
        case TEXTMODE: {
            struct textmode_context *ctx = (void *)term;
            memcpy32to64((uintptr_t)ctx, buf, sizeof(struct textmode_context));
            buf += sizeof(struct textmode_context);
            memcpy32to64((uintptr_t)ctx->back_buffer, buf, VD_ROWS * VD_COLS);
            buf += VD_ROWS * VD_COLS;
            memcpy32to64((uintptr_t)ctx->front_buffer, buf, VD_ROWS * VD_COLS);
            buf += VD_ROWS * VD_COLS;
            break;
        }
#endif
        case GTERM: {
            struct fbterm_context *ctx = (void *)term;
            memcpy32to64((uintptr_t)ctx, buf, sizeof(struct fbterm_context));
            buf += sizeof(struct fbterm_context);
            memcpy32to64((uintptr_t)ctx->font_bits, buf, ctx->font_bits_size);
            buf += ctx->font_bits_size;
            memcpy32to64((uintptr_t)ctx->font_bool, buf, ctx->font_bool_size);
            buf += ctx->font_bool_size;
            memcpy32to64((uintptr_t)ctx->canvas, buf, ctx->canvas_size);
            buf += ctx->canvas_size;
            memcpy32to64((uintptr_t)ctx->grid, buf, ctx->grid_size);
            buf += ctx->grid_size;
            memcpy32to64((uintptr_t)ctx->queue, buf, ctx->queue_size);
            buf += ctx->queue_size;
            memcpy32to64((uintptr_t)ctx->map, buf, ctx->map_size);
            buf += ctx->map_size;
            break;
        }
    }
}

void _term_write(uint64_t buf, uint64_t count) {
    switch (count) {
        case TERM_CTX_SIZE: {
            uint64_t ret = context_size();
            memcpy32to64(buf, (uint64_t)(uintptr_t)&ret, sizeof(uint64_t));
            return;
        }
        case TERM_CTX_SAVE: {
            context_save(buf);
            return;
        }
        case TERM_CTX_RESTORE: {
            context_restore(buf);
            return;
        }
        case TERM_FULL_REFRESH: {
            term->full_refresh(term);
            return;
        }
    }

    bool native = false;
#if defined (__x86_64__) || defined (__aarch64__)
    native = true;
#elif !defined (__i386__)
#error Unknown architecture
#endif

    bool autoflush = term->autoflush;
    term->autoflush = false;

    if (term->in_bootloader || native) {
        const char *s = (const char *)(uintptr_t)buf;

        term_write(term, s, count);
    } else {
#if defined (__i386__)
        while (count != 0) {
            uint64_t chunk;
            if (count > TERM_XFER_CHUNK) {
                chunk = TERM_XFER_CHUNK;
            } else {
                chunk = count;
            }

            memcpy32to64((uint64_t)(uintptr_t)xfer_buf, buf, chunk);

            term_write(term, (const char *)xfer_buf, chunk);

            count -= chunk;
            buf += chunk;
        }
#endif
    }

    if (autoflush) {
        term->double_buffer_flush(term);
    }

    term->autoflush = autoflush;
}
