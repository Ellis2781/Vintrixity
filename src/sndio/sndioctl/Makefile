# extra includes paths (-I options)
INCLUDE = -I../libsndio -I../bsd-compat

# extra libraries paths (-L options)
LIB = -L../libsndio

# extra defines (-D options)
DEFS = -DDEBUG -D_GNU_SOURCE -DHAVE_SOCK_CLOEXEC -DHAVE_CLOCK_GETTIME -DUSE_ALSA

# extra libraries (-l options)
LDADD = -lsndio -lrt -lasound

# variables defined on configure script command line (if any)
CC=clang
CFLAGS=-static -fPIE -pie -Wall


#
# binaries, documentation, man pages and examples will be installed in
# ${BIN_DIR}, ${MAN1_DIR}
#
BIN_DIR = /home/kc/Vintrixity/Vintrixity/src/../build/sysroot//System//sbin
MAN1_DIR = /home/kc/Vintrixity/Vintrixity/src/../build/sysroot//System//share/man/man1

#
# programs to build
#
PROG = sndioctl
MAN1 = sndioctl.1

all:		${PROG} ${MAN1}

install:
		mkdir -p ${DESTDIR}${BIN_DIR} ${DESTDIR}${MAN1_DIR}
		cp sndioctl ${DESTDIR}${BIN_DIR}
		cp sndioctl.1 ${DESTDIR}${MAN1_DIR}

uninstall:
		cd ${DESTDIR}${BIN_DIR} && rm -f ${PROG}
		cd ${DESTDIR}${MAN1_DIR} && rm -f ${MAN1}

clean:
		rm -f -- *.o sndioctl

# ---------------------------------------------------------- dependencies ---

OBJS = sndioctl.o

sndioctl:	${OBJS}
		${CC} ${LDFLAGS} ${LIB} -o sndioctl ${OBJS} ${LDADD}

.c.o:
		${CC} ${CFLAGS} ${INCLUDE} ${DEFS} -c $<

sndioctl.o:	sndioctl.c
