#! /bin/sh

LC_ALL=C
export LC_ALL

srcdir="$(dirname "$0")"
test -z "$srcdir" && srcdir=.

cd "$srcdir"

[ -f version ] || ( git describe --exact-match --tags $(git log -n1 --pretty='%h') 2>/dev/null || git log -n1 --pretty='%h' ) | sed 's/^v//g' | xargs printf '%s'
[ -f version ] && ( cat version 2>/dev/null ) | xargs printf '%s'
