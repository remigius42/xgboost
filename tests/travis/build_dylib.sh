#!/bin/bash

# cp make/travis.mk config.mk
# make -f dmlc-core/scripts/packages.mk lz4

# if [ ${TASK} == "build_dylib" ]; then
#     export PATH="/usr/local/bin:$PATH"
#     echo $PATH
#     export CC=gcc-7
#     export CXX=g++-7
#     echo "gcc info"
#     gcc --version
#     echo "end gcc info"
#     cp make/config.mk config.mk
#     #echo 'USE_OPENMP=0' >> config.mk
#     echo 'TMPVAR := $(XGB_PLUGINS)' >> config.mk
#     echo 'XGB_PLUGINS = $(filter-out plugin/lz4/plugin.mk, $(TMPVAR))' >> config.mk
#     make
# fi

if [ ${TASK} == "build_dylib" ]; then
    cp make/config.mk ./config.mk
    echo "gcc info"
    gcc --version
    make -j2
fi

if [ ${TASK} == "build_jvm" ]; then
    cp make/config.mk ./config.mk
    make jvm
fi
