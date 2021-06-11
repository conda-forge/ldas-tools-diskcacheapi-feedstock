#!/bin/bash

mkdir -p _build
pushd _build

# link librt to get clock_gettime on older glibc versions
if [ "$(uname)" == "Linux" ]; then
	export LDFLAGS="-lrt ${LDFLAGS}"
fi

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=true \
	-DWITH_SYSTEMDSYSTEMUNITDIR=no \
;

# build
cmake --build . --parallel ${CPU_COUNT}

# test
ctest -V

# install
cmake --build . --target install
