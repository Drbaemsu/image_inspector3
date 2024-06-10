#!/bin/sh

# 다운로드 및 파일 이동
curl -L -o /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64
chmod +x /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2

# 환경 변수 설정
export GRADIO_FRPC_PATH=/usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2

# Gradio 애플리케이션 실행
python app.py


