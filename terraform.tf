terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terra-backet"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"
    access_key = "key1"
    secret_key = "key2"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


# Configure the Yandex.Cloud provider
provider "yandex" {
  token                    = "token"
  cloud_id                 = "id"
  folder_id                = "id"
  zone                     = "ru-central1-a"
}





resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}


