from kafka import KafkaConsumer

consumer = KafkaConsumer(bootstrap_servers=['kafka:9092'])
topic = 'm6-homework'


def run_consumer(consumer: KafkaConsumer, topic: str):
    consumer.subscribe(topics=topic)
    [print(m) for m in consumer]
    consumer.close()


if __name__ == '__main__':
    print('Consumer started.')
    run_consumer(consumer=consumer, topic=topic)
    print('... closed.')
