data "exoscale_compute_template" "ubuntu" {
    zone = var.zone
    name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_instance_pool" "InstancePool_MyService" {
  name = "InstancePool_MyService"
  description = "Instance pool of my MyService"
  zone = var.zone
  template_id = data.exoscale_compute_template.ubuntu.id
  size = 3
  service_offering = "micro"
  disk_size = 10
  user_data = file("UserData/loadGen.sh")
  key_pair = exoscale_ssh_keypair.admin.name

  security_group_ids = [exoscale_security_group.web.id]
}
