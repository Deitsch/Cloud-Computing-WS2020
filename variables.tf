variable "zone" {
  type = string
  default = "at-vie-1"
}

variable "deitschPublicKey" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIRZi4s9oV+EK3dlA9qEDVHOal/I93DJWcW1UyCjhaaCMDW9NDXaTyRfIg90+GmcqHORA+BEpNdsPRThDULwwY9I2atwscfO3UmAFeo9GATsltOYsYzhGxUbRa2U+gHr/OgrvoX07PjQMUb6knLKO17yXX8OTJN9XqOkWwEulbGUEghZa0T908GuxzBF/663gb/pcVNis9IP7WZ2TZZrBpBVdfBvp1s60KDY8fucg5SkNihUSo5SJ7l1VU3dVlfLM8CVqClHykjcj72pm8uS+u3+SWjgAVz+9yXAQstW04vt/GkthDJbEKQEO6vPY5avUawVIyFCg/BXEGdK1ZgedL simondeutsch@Simons-MacBook-Pro.local"
}

resource "exoscale_ssh_keypair" "deitsch" {
  name       = "deitsch"
  public_key = var.deitschPublicKey
}