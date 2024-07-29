#!/bin/bash

# 필요한 디렉토리 생성
mkdir -p libs

# 라이브러리 경로 설정 (Homebrew 경로 확인)
CRYPTO_LIB_PATH=$(brew --prefix cryptopp)
GMP_LIB_PATH=$(brew --prefix gmp)

# 라이브러리 빌드
clang++ -std=c++11 -arch arm64 -fPIC -I${CRYPTO_LIB_PATH}/include -I${GMP_LIB_PATH}/include -I./src ./src/gHash.cpp -shared -o ./libs/gHash.so -L${CRYPTO_LIB_PATH}/lib -L${GMP_LIB_PATH}/lib -lgmp -lcryptopp
clang++ -std=c++11 -arch arm64 -fPIC -I${CRYPTO_LIB_PATH}/include -I${GMP_LIB_PATH}/include -I./src ./src/gHash.cpp -shared -o ./libs/libghash.so -L${CRYPTO_LIB_PATH}/lib -L${GMP_LIB_PATH}/lib -lgmp -lcryptopp

# 테스트 파일 빌드
clang++ -std=c++11 -arch arm64 -I${CRYPTO_LIB_PATH}/include -I${GMP_LIB_PATH}/include -I./src -L${CRYPTO_LIB_PATH}/lib -L${GMP_LIB_PATH}/lib -L./libs -lghash ./src/gHash_test.cpp -o test_ghash

# 테스트 실행
LD_LIBRARY_PATH=./libs/ ./test_ghash

# brew install gmp
# brew install cryptopp
# chmod +x script/build_for_m1.sh
# ./script/build_for_m1.sh