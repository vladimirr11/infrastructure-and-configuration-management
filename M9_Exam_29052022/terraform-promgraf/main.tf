terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

resource "docker_network" "private_network" {
    name = "appnet"
}

resource "docker_image" "img-prometheus" {
    name = "prom/prometheus"
}

resource "docker_image" "img-grafana" {
    name = "grafana/grafana"
}

resource "docker_container" "prometheus" {
    name = "prometheus"
    image = docker_image.img-prometheus.latest
    ports {
        internal = 9090
        external = 9090
    }
    networks_advanced {
        name = docker_network.private_network.name
    }
    volumes {
        host_path = "/vagrant/terraform-promgraf/prometheus.yml"
        container_path = "/etc/prometheus/prometheus.yml"
        read_only = true
    }
}

resource "docker_container" "grafana" {
    name = "grafana"
    image = docker_image.img-grafana.latest
    ports {
        internal = 3000
        external = 3000
    }
    networks_advanced {
        name = docker_network.private_network.name
    }
    volumes {
        host_path = "/vagrant/terraform-promgraf/datasource.yml"
        container_path = "/etc/grafana/provisioning/datasources/datasource.yaml"
        read_only = true
    }
}
