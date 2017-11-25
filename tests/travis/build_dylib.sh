#!/bin/bash

cp make/travis.mk config.mk
make -f dmlc-core/scripts/packages.mk lz4

if [ ${TASK} == "build_dylib" }; then
    cp make/config.mk config.mk
    #echo 'USE_OPENMP=0' >> config.mk
    echo 'TMPVAR := $(XGB_PLUGINS)' >> config.mk
    echo 'XGB_PLUGINS = $(filter-out plugin/lz4/plugin.mk, $(TMPVAR))' >> config.mk
    make
fi  
