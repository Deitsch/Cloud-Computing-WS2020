resource "exoscale_security_group" "web" {
  name = "web"
  description = "Security Group for webservice"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.web.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 80
  end_port = 80
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.web.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 22
  end_port = 22
}