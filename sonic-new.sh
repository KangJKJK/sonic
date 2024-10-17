#!/bin/bash

# 환경 변수 설정
export WORK="/root/sonic-tx-bot"
export NVM_DIR="$HOME/.nvm"

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}소닉 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
echo -e "${GREEN}출처: https://github.com/Widiskel/sonic-tx-bot${NC}"

echo -e "${CYAN}이 봇은 다음과 같은 기능을 갖고 있습니다.${NC}"
echo -e "${CYAN}오토체크인 / 100트잭 / 마일스톤클레임 / 미스테리박스클레임${NC}"

echo -e "${GREEN}설치 옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. 소닉 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 기존정보 그대로 이용하기(재실행)${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}소닉 봇을 새로 설치합니다.${NC}"

    # 사전 필수 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    sudo apt update
    sudo apt install -y git

    echo -e "${YELLOW}작업 공간 준비 중...${NC}"
    if [ -d "$WORK" ]; then
        echo -e "${YELLOW}기존 작업 공간 삭제 중...${NC}"
        rm -rf "$WORK"
    fi

    # GitHub에서 코드 복사
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/Widiskel/sonic-tx-bot.git "$WORK"
    cd "$WORK"

    # Node.js LTS 버전 설치 및 사용
    echo -e "${YELLOW}Node.js LTS 버전을 설치하고 설정 중...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    nvm install --lts
    nvm use --lts
    npm install

    # 개인키 입력받기
    read -p "Solana의 개인키를 쉼표로 구분하여 입력하세요: " privkeys
  
    # accounts.js 파일 생성
    cat <<EOL > "$WORK/accounts.js"
    export const account = [
    $(echo "$privkeys" | sed 's/,/\n/g' | sed 's/^/  "/;s/$/",/')
    ];
    EOL

    echo -e "${GREEN}accounts.js 파일이 성공적으로 생성되었습니다.${NC}"

    # 봇 구동
    node index.js
    ;;
    
  2)
    echo -e "${GREEN}소닉 봇을 재실행합니다.${NC}"
    cd "$WORK"
    git pull
    node index.js
    ;;

  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
esac
