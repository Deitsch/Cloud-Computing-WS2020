resource "exoscale_compute" "MyMonitoring" {
    display_name = "Monitoring-Instance"
    zone         = var.zone
    template_id  = data.exoscale_compute_template.ubuntu.id
    size         = "Micro"
    disk_size    = 10
    key_pair = exoscale_ssh_keypair.deitsch.name

    security_group_ids = [exoscale_security_group.SG_Monitoring.id]

    # user_data = file("UserData/prometheusInstance.sh")
    user_data = templatefile("UserData/monitoring.sh", {
        exoscale_key = var.exoscale_key,
        exoscale_secret = var.exoscale_secret,
        exoscale_zone = var.zone,
        exoscale_instancepool_id = exoscale_instance_pool.InstancePool_MyService.id,
        target_port = "9100",
        targetFilePath = "/srv/service-discovery",
        listen_port = "8090"
    })
}