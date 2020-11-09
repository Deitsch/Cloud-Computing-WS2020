# Securtiy Group for MyService

resource "exoscale_security_group" "SG_MyService" {
  name = "SG_MyService"
  description = "Security Group for service"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.SG_MyService.id
  type = "INGRESS"
  protocol = "TCP"
  cidr = "0.0.0.0/0"
  start_port = 8080
  end_port = 8080
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.SG_MyService.id
  type = "INGRESS"
  protocol = "TCP"
  cidr = "0.0.0.0/0"
  start_port = 22
  end_port = 22
}

# Securtiy Group for Prometheus Instance

resource "exoscale_security_group" "SG_Prometheus" {
  name = "SG_Prometheus"
  description = "Security Group for Prometheus Instance"
}

resource "exoscale_security_group_rule" "prom" {
  security_group_id = exoscale_security_group.SG_Prometheus.id
  type = "INGRESS"
  protocol = "TCP"
  cidr = "0.0.0.0/0"
  start_port = 9090
  end_port = 9090
}

resource "exoscale_security_group_rule" "prom_ssh" {
  security_group_id = exoscale_security_group.SG_Prometheus.id
  type = "INGRESS"
  protocol = "TCP"
  cidr = "0.0.0.0/0"
  start_port = 22
  end_port = 22
}