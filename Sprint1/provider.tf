terraform {
  required_providers {
    exoscale = {
      source  = "terraform-providers/exoscale"
    }
  }
}
provider "exoscale" {
  key = var.exoscale_key
  secret = var.exoscale_secret
}

variable "exoscale_key" {
  type = string
}

variable "exoscale_secret" {
  type = string
}
