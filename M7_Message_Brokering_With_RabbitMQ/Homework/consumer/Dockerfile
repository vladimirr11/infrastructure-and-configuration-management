FROM python:3.8-slim

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir pika

WORKDIR /consumer

ADD ./consumer/consumer.py .

ENTRYPOINT [ "python", "-m", "consumer.py" ]
