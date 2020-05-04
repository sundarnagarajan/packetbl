#!/bin/bash
PROG_DIR=$(readlink -e $(dirname $0))
cd "${PROG_DIR}"

VERSION=$(grep '^Version: ' debian/binary-control | awk '{print $2}')
PKG_NAME="packetbl"

BUILD_DIR=${PROG_DIR}/deb_build
PKG_NAME_DIR="${BUILD_DIR}/${PKG_NAME}-${VERSION}"
SRC_DIR="${PKG_NAME_DIR}/src"

# VERBOSE_FLAG="-v "
VERBOSE_FLAG=" "

function create_dirs() {
    cd "${PROG_DIR}"
    rm -rf "${BUILD_DIR}"
    mkdir -p "${PKG_NAME_DIR}/bin"
    cp -a ${VERBOSE_FLAG} "${PROG_DIR}/debian" "${PKG_NAME_DIR}"/
    cp -a ${VERBOSE_FLAG} "${PROG_DIR}/src" "${PKG_NAME_DIR}/"
    cp -a ${VERBOSE_FLAG} "${PROG_DIR}/pkg_files" "${PKG_NAME_DIR}/"
}


function clean_src() {
    cd "${BUILD_DIR}"
    rm -f ${VERBOSE_FLAG} ../*.buildinfo ../*.changes ../*.deb ../*.dsc ../*.ddeb ../*.tar.gz

    cd "${PKG_NAME_DIR}"
    rm -f ${VERBOSE_FLAG} *.deb
    mkdir -p ${VERBOSE_FLAG} bin
    rm -f ${VERBOSE_FLAG} bin/*
    rm -rf ${VERBOSE_FLAG} debian/packetbl/usr debian/packetbl/etc
    rm -rf ${VERBOSE_FLAG} debian/.debhelper debian/debhelper-build-stamp
    rm -rf ${VERBOSE_FLAG} debian/packetbl.debhelper.log debian/packetbl/DEBIAN/md5sums

    cd "${SRC_DIR}"
    make distclean
}

function build() {
    cd "${PKG_NAME_DIR}"
    dpkg-buildpackage -S || return 1
    dpkg-buildpackage -B || return 1
}

function show_result() {
    cd "${BUILD_DIR}"
    BIN_DEB=$(basename $(ls -1t *.deb | head -1))
    echo "===================================================================="
    echo "DEB built: $BIN_DEB"
    echo "===================================================================="
    dpkg-deb --info ${BIN_DEB}
    dpkg-deb --contents ${BIN_DEB}
}


create_dirs
clean_src

build
ret=$?
if [ $ret -ne 0 ]; then
    exit $ret
fi

show_result
# clean_src
