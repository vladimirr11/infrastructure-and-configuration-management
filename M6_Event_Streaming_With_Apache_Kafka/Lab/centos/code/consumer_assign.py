from kafka import KafkaConsumer, TopicPartition
print('Consumer started. Press Ctrl+C to stop.')

try:
    consumer = KafkaConsumer(bootstrap_servers=['kafka-1:9092','kafka-2:9092','kafka-3:9092'])
    consumer.assign([TopicPartition('demo2', 1), TopicPartition('demo3', 2)])
    for message in consumer:
        print(message)
except Exception as ex:
    print(str(ex))
except KeyboardInterrupt:
    pass
finally:
    if consumer is not None:
        consumer.close()

print('... closed.')

