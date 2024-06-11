#!/bin/sh

# 환경 변수 설정
export GRADIO_FRPC_PATH=/app/frpc_linux_amd64_v0.2

# Gradio 애플리케이션 실행
exec "$@"
