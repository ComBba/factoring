#!/bin/bash

# 현재 실행 위치를 프로젝트 디렉터리로 설정
PROJECT_DIR=$(cd "$(dirname "$0")/.." && pwd)

# 필요한 환경 변수 설정
export SCRIPTPUBKEY="0014c7a460fc004f380619fd64b5080f09d87ebfced1"
export RPC_USER="2weeks"
export RPC_PASS="2weeksskeew2"
export YAFU_THREADS=$(($(nproc) - 1))
export YAFU_LATHREADS=$(($(nproc) - 1))
export MSIEVE_BIN="$PROJECT_DIR/libs"

# 필요한 디렉터리가 존재하는지 확인하고, 없는 경우 생성
if [ ! -d "$MSIEVE_BIN" ]; then
    echo "디렉터리가 존재하지 않습니다. 디렉터리를 생성합니다: $MSIEVE_BIN"
    mkdir -p "$MSIEVE_BIN"
fi

# 필요한 파일 확인 및 복사
REQUIRED_FILES=("libs/gHash.so" "libs/libghash.so")

for FILE in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$PROJECT_DIR/$FILE" ]; then
        echo "필요한 파일이 없습니다: $FILE"
        exit 1
    else
        cp "$PROJECT_DIR/$FILE" "$MSIEVE_BIN/"
    fi
done

# Python 환경 설정 및 종속성 설치
echo "Python 라이브러리 설치 중..."
pip install -r $PROJECT_DIR/python/requirements.txt

# 스크립트 실행
echo "스크립트 실행 중..."
python3 $PROJECT_DIR/python/FACTOR.py
