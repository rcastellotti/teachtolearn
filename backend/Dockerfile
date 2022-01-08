FROM docker.io/python:3.9-alpine
RUN apk update && apk --no-cache add python3-dev  libffi-dev  build-base 
WORKDIR /app
ADD . .
RUN pip3 install -r requirements.txt
EXPOSE 5000
