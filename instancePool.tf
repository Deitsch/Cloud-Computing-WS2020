data "exoscale_compute_template" "ubuntu" {
    name = "Linux Ubuntu 20.04 LTS 64-bit"
    zone = var.zone
}

resource "exoscale_instance_pool" "InstancePool_MyService" {
  name = "InstancePool_MyService"
  description = "Instance pool of my MyService"
  zone = var.zone
  template_id = data.exoscale_compute_template.ubuntu.id
  size = 2
  service_offering = "micro"
  disk_size = 10
  user_data = file("UserData/loadGenerator+NodeExporter.sh")
  key_pair = exoscale_ssh_keypair.deitsch.name

  security_group_ids = [exoscale_security_group.SG_MyService.id]
}
