#!/bin/bash

if ! command -v nvcc &> /dev/null; then
    echo "ERROR: nvcc not found in PATH. Load your CUDA environment first."
    exit 1
fi

mkdir -p build/out
cd build

cmake .. \
    -DOPENMP_RUNTIME=NONE \
    -DWITH_MKL=OFF \
    -DWITH_CUDA=ON \
    -DWITH_CUDNN=ON \
    -DWITH_FLASH_ATTN=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$(pwd)/out

make -j 6
make install

cd ../python
pip uninstall -y ctranslate2
rm -rf CTranslate2.egg-info
rm ctranslate2/*.so*
cp ../build/out/lib/libctranslate2.so* ctranslate2/
pip install -e .


