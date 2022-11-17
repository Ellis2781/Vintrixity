# This is a -*-perl-*- script
#
# Set variables that were defined by configure, in case we need them
# during the tests.

%CONFIG_FLAGS = (
    AM_LDFLAGS      => '-Wl,--export-dynamic',
    AR              => 'ar',
    CC              => 'gcc',
    CFLAGS          => '-g -O2',
    CPP             => 'gcc -E',
    CPPFLAGS        => '',
    GUILE_CFLAGS    => '-I/usr/include/guile/2.2 -pthread ',
    GUILE_LIBS      => '-lguile-2.2 -lgc ',
    LDFLAGS         => '',
    LIBS            => '',
    USE_SYSTEM_GLOB => 'yes'
);

1;
