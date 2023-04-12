terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "y0_AgAAAABByXFIAATuwQAAAADe1FCEulHBajvyRwaieGlXILbk_iRNboU"
  cloud_id  = "b1g94rkpor2gc6kb4uck"
  folder_id = "b1g3n2smqd9pns84pu21"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "web1"
  hostname = "web1.test.netology"
  platform_id = "standard-v1"
  #allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
      #data.yandex_compute_image.lemp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    #gateway_id         = yandex_vpc_gateway.egress-gateway.id
    #nat       = true
    security_group_ids  = [yandex_vpc_security_group.in_sg.id]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
    serial-port-enable = 1
  }

 # scheduling_policy {
 #   preemptible = true
 # }
}

resource "yandex_compute_instance" "vm-2" {
  name = "web2"
  hostname = "web2.test.netology"
  platform_id = "standard-v1"
  #allow_stopping_for_update = true
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
      #data.yandex_compute_image.lemp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    security_group_ids  = [yandex_vpc_security_group.in_sg.id]
    #nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
    serial-port-enable = 1
    #gateway_id         = yandex_vpc_gateway.egress-gateway.id
    #security_group_id  = "${yandex_vpc_security_group.test-sg1.id}"
  }

  #scheduling_policy {
 #   preemptible = true
 # }
}

resource "yandex_compute_instance" "vm-3" {
  name = "prom"
  hostname = "prom.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    security_group_ids  = [yandex_vpc_security_group.in_sg.id]
    #nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
    serial-port-enable = 1
    #gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }

  #scheduling_policy {
  #  preemptible = true
  #}
}

resource "yandex_compute_instance" "vm-4" {
  name = "graf"
  hostname = "graf.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
    security_group_ids  = [yandex_vpc_security_group.out_sg.id]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

 # scheduling_policy {
 #   preemptible = true
 # }
}

resource "yandex_compute_instance" "vm-5" {
  name = "elast"
  hostname = "elast.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      size = "15"
      image_id = "fd8snjpoq85qqv0mk9gi"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    security_group_ids  = [yandex_vpc_security_group.in_sg.id]
    #nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
    serial-port-enable = 1
    #gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }

 # scheduling_policy {
 #   preemptible = true
 # }
}

resource "yandex_compute_instance" "vm-6" {
  name = "kib"
  hostname = "kib.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
    security_group_ids  = [yandex_vpc_security_group.out_sg.id]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

 # scheduling_policy {
 #   preemptible = true
  #}
}

resource "yandex_compute_instance" "vm-7" {
  name = "bastion"
  hostname = "bastion.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    security_group_ids  = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

 # scheduling_policy {
 #   preemptible = true
  #}
}

resource "yandex_alb_target_group" "test-target-group" {
  name           = "ttg"

  target {
    subnet_id    = yandex_vpc_subnet.subnet-1.id
    ip_address   = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet-2.id
    ip_address   = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name                     = "tbg"
  session_affinity {
    connection {
      source_ip = true
    }
  }

  http_backend {
    name                   = "test-http-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = ["${yandex_alb_target_group.test-target-group.id}"]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "180s"
      interval             = "120s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name   = "tfr"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "mvh"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "tf-rout"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "test-balancer"
  network_id  = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-1.id 
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent = 75
    }
  }
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "myegress-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "lab-rt-a" {
  network_id = yandex_vpc_network.network-1.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.128.0.0/24"]
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.129.0.0/24"]
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}

output "internal_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.ip_address
}

output "internal_ip_address_vm_5" {
  value = yandex_compute_instance.vm-5.network_interface.0.ip_address
}

output "internal_ip_address_vm_6" {
  value = yandex_compute_instance.vm-6.network_interface.0.ip_address
}

output "internal_ip_address_vm_7" {
  value = yandex_compute_instance.vm-7.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_5" {
  value = yandex_compute_instance.vm-5.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_6" {
  value = yandex_compute_instance.vm-6.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_7" {
  value = yandex_compute_instance.vm-7.network_interface.0.nat_ip_address
}