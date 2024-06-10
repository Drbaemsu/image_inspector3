# 베이스 이미지 설정
FROM python:3.9-slim

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y wget

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 파일 복사 및 의존성 설치
COPY requirements.txt .
RUN pip install -r requirements.txt

# frpc_linux_amd64_v0.2 파일 다운로드 및 복사
RUN wget -O /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64
RUN chmod +x /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2

# 애플리케이션 파일 복사
COPY . .

# 애플리케이션 실행 명령 설정
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
