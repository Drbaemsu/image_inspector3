#!/bin/sh

# 다운로드 및 파일 이동
wget -O /tmp/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64
chmod +x /tmp/frpc_linux_amd64_v0.2

# 필요시 디렉토리 생성
mkdir -p /usr/local/lib/python3.9/site-packages/gradio

# 파일 이동
mv /tmp/frpc_linux_amd64_v0.2 /usr/local/lib/python3.9/site-packages/gradio/

# Gradio 애플리케이션 실행
python app.py
