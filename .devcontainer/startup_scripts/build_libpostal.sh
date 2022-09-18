#!/usr/bin/env bash
# see: https://github.com/scpike/libpostal-docker/blob/master/build_libpostal.sh
./bootstrap.sh
mkdir -p /opt/libpostal_data
./configure --datadir=/opt/libpostal_data
make
make install
ldconfig
