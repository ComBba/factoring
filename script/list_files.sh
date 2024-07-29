#!/bin/bash

# list_files.sh
# 이 스크립트는 프로젝트 루트 디렉토리에서 실행하여 모든 파일의 경로를 출력합니다.

# 프로젝트 루트 디렉토리 확인
PROJECT_ROOT=$(pwd)
echo "Project root directory: $PROJECT_ROOT"
echo ""

# 모든 파일 목록 출력
echo "Listing all files in the project:"
echo "---------------------------------"
find "$PROJECT_ROOT" -type f
