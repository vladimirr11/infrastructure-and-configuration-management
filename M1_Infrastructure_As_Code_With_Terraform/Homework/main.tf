terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {
    host = "tcp://192.168.99.100:2375/"
}

resource "docker_network" "private_network" {
    name = var.v_net
}

resource "docker_image" "web-img" {
    name = var.bgapp_web_image
}

resource "docker_image" "db-img" {
    name = var.bgapp_db_image
}

resource "docker_container" "con-web" {
    name = var.v_web_con_name
    image = docker_image.web-img.name
    restart = var.v_restart
    ports {
        internal = var.v_int_port
        external = var.v_ext_port
    }
    networks_advanced {
        name = var.v_net
    }
    depends_on = [
        docker_network.private_network
    ]
}

resource "docker_container" "con-db" {
    name = var.v_db_con_name
    image = docker_image.db-img.latest
    restart = var.v_restart
    networks_advanced {
        name = var.v_net
    }
    env = [
        "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}"
    ]
    depends_on = [
        docker_network.private_network
    ]    
}
