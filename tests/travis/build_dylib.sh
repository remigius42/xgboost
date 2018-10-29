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

if [ ${TASK} == "build_jvm" ]; then
    cp make/config.mk ./config.mk
    sed -ie 's/# export CC = gcc/export CC = gcc-7/g' config.mk
    sed -ie 's/# export CXX = g++/export CXX = g++-7/g' config.mk
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
    make -j4
    #echo "make complete"
    #make jvm
    #echo "make jvm complete"
    cd jvm-packages
    mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=error -Dcheckstyle.skip=true package -P release,assembly
    echo -e "mvn package complete\n"
    ls xgboost4j/target/
    ls ../lib
    otool -L ../lib/libxgboost4j.dylib
    #echo "Running custom test"
    #cd ../tests
    #javac -cp ../jvm-packages/xgboost4j/target/xgboost4j-0.7-jar-with-dependencies.jar:. XGBoostTest.java
    #java -cp ../jvm-packages/xgboost4j/target/xgboost4j-0.7-jar-with-dependencies.jar:. XGBoostTest
fi
