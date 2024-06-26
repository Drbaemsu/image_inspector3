FROM python:3.9.6

# 필수 패키지 설치
COPY apt.yml /app/apt.yml
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1-mesa-glx \
    libatlas-base-dev \
    gfortran \
    python3-opencv

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사 및 설치
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 로컬에서 다운로드한 frpc_linux_amd64_v0.2 파일 복사 및 설정
COPY frpc_linux_amd64_v0.2 /app/frpc_linux_amd64_v0.2
RUN chmod +x /app/frpc_linux_amd64_v0.2

# 애플리케이션 파일 복사
COPY . /app

# naver_map_images 디렉토리 생성 및 권한 부여
RUN mkdir /app/naver_map_images && chmod -R 777 /app/naver_map_images
RUN mkdir /app/flagged && chmod -R 777 /app/flagged
RUN mkdir -p /tmp/.config/matplotlib && chmod -R 777 /tmp/.config/matplotlib

# entrypoint.sh 복사 및 실행 권한 설정
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 환경 변수 설정
ENV MPLCONFIGDIR=/tmp/.config/matplotlib

# 애플리케이션 시작
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python", "app.py"]


