#!/bin/sh
PROG_DIR=$(readlink -e $(dirname $0))
cd "$PROG_DIR"
make -f Makefile.in clean
./configure --with-firedns --with-stats --with-stats-socket=/tmp/.packetbl.sock
make deb
