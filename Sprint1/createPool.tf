variable "zone" {
    default = "at-vie-1"
    type = string
}

variable "nginx" {
    default = <<EOF
        #!/bin/bash
        set -e
        apt update
        apt install -y nginx
        EOF
  type = string
}

variable "instanceCount" {
    default = "3"
    type = string
}

resource "exoscale_network" "web_privnet" {
    zone = var.zone
    name = "web_privnet"
}

data "exoscale_compute_template" "ubuntu" {
    zone = var.zone
    name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_instance_pool" "webapp" {
  zone = var.zone
  name = "webapp"
  template_id = data.exoscale_compute_template.ubuntu.id
  size = var.instanceCount
  service_offering = "micro"
  disk_size = 10
  description = "Instance pool of the web app"
  user_data = var.nginx
  key_pair = ""

  security_group_ids = [exoscale_security_group.web.id]
  network_ids = [exoscale_network.web_privnet.id]

  timeouts {
    delete = "10m"
  }
}