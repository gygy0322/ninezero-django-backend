#  Python 3.11이 설치된 Alpine Linux 3.19
#  alpine 3.19 버전의 리눅스를 구축하는데, 파이썬 버전은 3.11fh 설치된 이미지를 불러와줘
# Alpine Linux는 경량화된 리눅스 배포판으로, 컨테이너 환경에 적합
# 빌드가 계속 반복되는데, 이미지 자체가 무거우면 빌드 속도가 느려진다
FROM python:3.11-alpine3.19

# LABEL 명령어는 이미지에 메타데이터를 추가합니다. 여기서는 이미지의 유지 관리자를 "seopftware"로 지정하고 있습니다.
LABEL maintainer="ninezero"

# 환경 변수 PYTHONUNBUFFERED를 1로 설정합니다.
# 이는 Python이 표준 입출력 버퍼링을 비활성화하게 하여, 로그가 즉시 콘솔에 출력되게 합니다.
# 이는 Docker 컨테이너에서 로그를 더 쉽게 볼 수 있게 합니다.
# 컨테이너에 찍히는 로그를 볼 수 있도록 한다.
# 도커 컨테이너에서 어떤 일이 벌어지고 있는 지 알아야지 디버깅이 편리
# 실시간으로 볼 수 있기 때문에 컨테이너 관리가 편해진다.
ENV PYTHONUNBUFFERED 1

# 로컬 파일 시스템의 requirements.txt 파일을 컨테이너의 /tmp/requirements.txt로 복사합니다.
# 이 파일은 필요한 Python 패키지들을 명시합니다.
# tmp에 넣는 이유: 컨테이너를 최대한 경량상태로 유지하기 위해
# tmp 폴더는 나중에 빌드가 완료되면 삭제합니다.
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# COPY ./app /app

# WORKDIR /app
EXPOSE 8000

ARG DEV=false

# && \: Enter
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
#     if [ $DEV = "true" ]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
#    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# Django(Scikit-learn => REST API) - Docker - Github Actions(CI/CD)
