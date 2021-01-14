resource "exoscale_nlb" "NLB_MyService" {
  name = "NLB_MyService"
  description = "Managed by Terraform"
  zone = var.zone
}

resource "exoscale_nlb_service" "NLB_Service_MyService" {
  name = "NLB_Service_MyService"
  description = "Managed by Terraform"
  zone = exoscale_nlb.NLB_MyService.zone
  nlb_id = exoscale_nlb.NLB_MyService.id
  instance_pool_id = exoscale_instance_pool.InstancePool_MyService.id
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