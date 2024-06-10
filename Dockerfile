FROM python:3.9.6

# 필수 패키지 설치
COPY apt.yml /app/apt.yml
RUN apt-get update && apt-get install -y $(cat /app/apt.yml | grep -E '^\s*-\s*' | cut -d'-' -f2)

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사 및 설치
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 로컬에서 다운로드한 frpc_linux_amd64_v0.2 파일 복사 및 설정
COPY frpc_linux_amd64_v0.2 /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2
RUN chmod +x /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2

# 애플리케이션 파일 복사
COPY . /app

# 실행 권한 설정
RUN chmod +x /app/start.sh

# 애플리케이션 시작
CMD ["sh", "start.sh"]