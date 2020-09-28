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
  description = "Exoscale Key"
  type = string
}

variable "exoscale_secret" {
  description = "Exoscale Secret"
  type = string
}
