#!/bin/bash

set -e

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
    export PATH="/usr/local/bin:$PATH"
    echo $PATH
    #export CC=gcc-7
    #export CXX=g++-7
    export CC=gcc-6
    export CXX=g++-6
    echo "gcc info"
    g++-7 --version
    cp make/config.mk ./config.mk
    make -j2
fi

if [ ${TASK} == "build_jvm" ]; then
    export PATH="/usr/local/bin:$PATH"
    echo $PATH
    #export CC=gcc-7
    #export CXX=g++-7
    export CC=gcc-6
    export CXX=g++-6
    echo "g++ info"
    g++-6 --version || echo "g++-6 not available"
    g++-7 --version || echo "g++-7 not available"
    echo "java_home: ${JAVA_HOME}"
    export JAVA_HOME=$(/usr/libexec/java_home)
    echo "java_home: ${JAVA_HOME}"
    which javac
    javac -version
    echo "javac in JAVA_HOME"
    ${JAVA_HOME}/bin/javac -version
    echo "ls JAVA_HOME headers"
    ls ${JAVA_HOME}/include
    echo "ls JAVA_HOME headers darwin"
    ls ${JAVA_HOME}/include/darwin
    echo "ls system Java headers"
    ls /System/Library/Frameworks/JavaVM.framework/Headers
    cp make/config.mk ./config.mk
    make -j2
    echo "make complete"
    make jvm
    echo "make jvm complete"
    #cd jvm-packages
    #mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=error -Dcheckstyle.skip=true package
    #echo -e "mvn package complete\n"
    #echo "Running custom test"
    #cd ../tests
    #javac -cp ../jvm-packages/xgboost4j/target/xgboost4j-0.7-jar-with-dependencies.jar:. XGBoostTest.java
    #java -cp ../jvm-packages/xgboost4j/target/xgboost4j-0.7-jar-with-dependencies.jar:. XGBoostTest
fi
