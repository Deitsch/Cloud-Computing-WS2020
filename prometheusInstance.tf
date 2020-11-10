resource "exoscale_compute" "MyPrometheus" {
    display_name = "Prometheus-Monitoring-Instance"
    zone         = var.zone
    template_id  = data.exoscale_compute_template.ubuntu.id
    size         = "Micro"
    disk_size    = 10
    key_pair = exoscale_ssh_keypair.deitsch.name

    security_group_ids = [exoscale_security_group.SG_Prometheus.id]

    # user_data = file("UserData/prometheusInstance.sh")
    user_data = templatefile("UserData/prometheusInstance.sh", {
        exoscale_key = var.exoscale_key,
        exoscale_secret = var.exoscale_secret,
        exoscale_zone = var.zone
    })
}