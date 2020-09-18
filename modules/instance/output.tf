
output "client_external_ip" {
    value = google_compute_instance.client.network_interface.0.access_config.0.nat_ip
}


output "client_internal_ip" {
    value = google_compute_instance.client.network_interface.0.network_ip
}

output "server_external_ip" {
  value = google_compute_instance.client.network_interface.0.access_config.0.nat_ip
}
