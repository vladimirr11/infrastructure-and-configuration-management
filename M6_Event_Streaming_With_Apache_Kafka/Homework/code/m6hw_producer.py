from kafka import KafkaProducer
from time import sleep
from random import randrange

tpk = 'm6-homework'
cycle, target_c = (1, 11)
producer = KafkaProducer(bootstrap_servers=['kafka:9092'])


def send_bytes_and_sleep(producer: KafkaProducer, cycle: int):
    print(f'Cycle number {cycle}')
    producer.send(tpk, bytes(f'Cycle number {cycle}', encoding='utf-8'))
    producer.flush()
    slp = randrange(1, 10)
    print(f'Sleep for {slp} second(s).')
    sleep(slp)


def run_producer(producer: KafkaProducer):
    [send_bytes_and_sleep(producer, cycle) for cycle in range(target_c)]
    producer.close()


if __name__ == '__main__':
    print(f'Producer started for 10 cycles. Working on topic={tpk}')
    run_producer(producer=producer)
    print('... producer closed.')
