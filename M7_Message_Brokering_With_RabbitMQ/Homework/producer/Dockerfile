FROM python:3.8-slim

WORKDIR /producer

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir pika

ADD ./producer/producer.py .

ENTRYPOINT [ "python", "-m", "producer.py" ]
