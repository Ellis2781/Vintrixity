#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <lib/fb.h>
#include <drivers/vbe.h>
#include <drivers/gop.h>
#include <mm/pmm.h>

bool fb_init(struct fb_info *ret,
             uint64_t target_width, uint64_t target_height, uint16_t target_bpp) {
    bool r;

#if defined (BIOS)
    r = init_vbe(ret, target_width, target_height, target_bpp);
#elif defined (UEFI)
    r = init_gop(ret, target_width, target_height, target_bpp);
#endif

    return r;
}

struct fb_info *fb_get_mode_list(size_t *count) {
#if defined (BIOS)
    return vbe_get_mode_list(count);
#elif defined (UEFI)
    return gop_get_mode_list(count);
#endif
}

void fb_clear(struct fb_info *fb) {
    for (size_t y = 0; y < fb->framebuffer_height; y++) {
        switch (fb->framebuffer_bpp) {
            case 32: {
                uint32_t *fbp = (void *)(uintptr_t)fb->framebuffer_addr;
                size_t row = (y * fb->framebuffer_pitch) / 4;
                for (size_t x = 0; x < fb->framebuffer_width; x++) {
                    fbp[row + x] = 0;
                }
                break;
            }
            case 16: {
                uint16_t *fbp = (void *)(uintptr_t)fb->framebuffer_addr;
                size_t row = (y * fb->framebuffer_pitch) / 2;
                for (size_t x = 0; x < fb->framebuffer_width; x++) {
                    fbp[row + x] = 0;
                }
                break;
            }
            default: {
                uint8_t *fbp = (void *)(uintptr_t)fb->framebuffer_addr;
                size_t row = y * fb->framebuffer_pitch;
                for (size_t x = 0; x < fb->framebuffer_width * fb->framebuffer_bpp; x++) {
                    fbp[row + x] = 0;
                }
                break;
            }
        }
    }
}
