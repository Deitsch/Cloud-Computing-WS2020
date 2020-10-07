resource "exoscale_security_group" "web" {
  name = "web"
  description = "Security Group for webservice"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.web.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 8080
  end_port = 8080
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.web.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 22
  end_port = 22
}

resource "exoscale_ssh_keypair" "admin" {
  name       = "admin"
  public_key = var.deitschPublicKey
}
