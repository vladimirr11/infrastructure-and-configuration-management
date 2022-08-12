terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

resource "docker_image" "img-prod" {
    name = "shekeriev/rabbit-prod"
}

resource "docker_image" "img-cons" {
    name = "shekeriev/rabbit-cons"
}

resource "docker_container" "producer" {
    name = "rabbitmq-producer"
    image = docker_image.img-prod.latest
    env = ["BROKER=rabbitmq", "BROKERPORT=5672", "TOPIC=exam"]
    networks_advanced {
        name = "appnet"
    }
}

resource "docker_container" "consumer" {
    name = "rabbitmq-consumer"
    image = docker_image.img-prod.latest
    env = ["BROKER=rabbitmq", "BROKERPORT=5672", "EXCHANGE=exam", "TOPICS=exam.*"]
    networks_advanced {
        name = "appnet"
    }
}
