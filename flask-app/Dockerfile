FROM alpine:latest
MAINTAINER Saltydev42

RUN apk add --update python3 py-pip && \
        apk add python3-dev postgresql-dev gcc musl-dev && \
        mkdir -vp /app/config

COPY requirements.txt /app
WORKDIR /app

RUN pip3 install -r requirements.txt
RUN apk del gcc python3-dev musl-dev
COPY flaskr /app/flaskr

COPY ca.crt.pem .
COPY entrypoint.sh .
RUN cat ca.crt.pem >> /usr/lib/python3.8/site-packages/certifi/cacert.pem && \
        chmod -R 755 flaskr entrypoint.sh && \
        chmod 4777 /app


CMD ["./entrypoint.sh"]
