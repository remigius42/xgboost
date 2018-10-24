#!/bin/bash
set -e

if [ ${TASK} == "build_dylib" ]; then
    cp make/config.mk ./config.mk
    sed -ie 's/# export CC = gcc/export CC = gcc-7/g' config.mk
    sed -ie 's/# export CXX = g++/export CC = g++-7/g' config.mk
    echo "pwd:"
    pwd
    echo "./config.mk"
    cat ./config.mk
    echo "-----"
    
    export PATH="/usr/local/bin:$PATH"
    echo $PATH
    export CC=gcc-7
    export CXX=g++-7
    echo "gcc info"
    g++-7 --version
    echo "build start"
    make -j4
fi

