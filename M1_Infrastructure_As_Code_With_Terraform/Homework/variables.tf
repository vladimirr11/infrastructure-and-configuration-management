variable "bgapp_web_image" {
    description = "BGApp web image."
    default = "shekeriev/bgapp-web:embedded"
}

variable "bgapp_db_image" {
    description = "BGApp db image."
    default = "shekeriev/bgapp-db"
}

variable "v_web_con_name" {
    description = "Web container name"
    default = "web"
}

variable "v_db_con_name" {
    description = "Db container name"
    default = "db"
}

variable "v_int_port" {
    description = "Internal port"
    default = 80
}

variable "v_ext_port" {
    description = "External port"
    default = 80
}

variable "v_net" {
    description = "Common network"
    default = "bgapp-net"
}

variable "v_restart" {
    description = "The restart policy for the container"
    default = "always"
}

variable "mysql_root_password" {
    description = "MySQL root password"
    default = "Password1"
}
