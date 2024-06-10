# 다운로드 및 파일 이동
curl -L -o /tmp/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64
chmod +x /tmp/frpc_linux_amd64_v0.2

# 필요시 디렉토리 생성
mkdir -p /app/gradio

# 파일 이동
mv /tmp/frpc_linux_amd64_v0.2 /app/gradio/

# 애플리케이션 실행
python app.py
