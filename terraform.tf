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
    access_key = "YCAJEn3joXehj-eV6DXQlJBnF"
    secret_key = "YCNLJrMih2-K7wzGqUi8HAgtOcxVWcobbwaUlXyI"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


# Configure the Yandex.Cloud provider
provider "yandex" {
  token                    = "y0_AgAAAAAE4kzuAATuwQAAAADY4Aa-DEYAxMNkSkOTL17brUgnk4GZ9_4"
  cloud_id                 = "b1gjmf3d3m081752e5tg"
  folder_id                = "b1gsm35pjg8ov6j472ro"
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


