# ninezero-django-backend

### 도커 빌드
docker build .
docker-compose build

### 장고 세팅
docker-compose run --rm app sh -c "django-admin startproject app ."

### admin 계정 생성
docker-compose run --rm app sh -c "python manage.py migrate"
docker-compose run --rm app sh -c "python manage.py createsuperuser"
ninezero1234
