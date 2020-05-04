#!/bin/sh
make -f Makefile.in clean
./configure --with-firedns --with-stats --with-stats-socket=/tmp/.packetbl.sock
make deb
