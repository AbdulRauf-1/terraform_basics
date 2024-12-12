terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
    name= "nginx:latest"
    keep_locally=false
}

resource "docker_container" "nginx" {
    name="nginx-tf"
    image=docker_image.nginx.image_id
    ports {
        internal=80
        external=8080
    }
}

