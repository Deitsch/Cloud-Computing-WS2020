resource "exoscale_nlb" "webservice" {
  name = "webservice"
  description = "This is the Network Load Balancer for my webservice"
  zone = var.zone
}

resource "exoscale_nlb_service" "webservice" {
  description = "Webservice over HTTP"
  zone = exoscale_nlb.webservice.zone
  name = "webservice"
  nlb_id = exoscale_nlb.webservice.id
  instance_pool_id = exoscale_instance_pool.webservice.id
    protocol = "tcp"
    port = 80
    target_port = 8080
    strategy = "round-robin"

  healthcheck {
    port = 8080
  //  mode = "tcp"
    mode = "http"
    uri = "/health"
    interval = 5
    timeout = 3
    retries = 1
  }
}