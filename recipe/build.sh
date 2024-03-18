#!/bin/bash

mkdir -p _build
pushd _build

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DBUILD_TESTING:BOOL=true \
	-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen:BOOL=true \
	-DCMAKE_OSX_ARCHITECTURES:STRING="${OSX_ARCH}" \
	-DWITH_SYSTEMDSYSTEMUNITDIR:BOOL=no \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	# see https://git.ligo.org/computing/ldastools/LDAS_Tools/-/issues/111
	ctest --verbose \
	  -R "test_diskcache" \
	;
fi

# install
cmake --build . --parallel ${CPU_COUNT} --verbose --target install
