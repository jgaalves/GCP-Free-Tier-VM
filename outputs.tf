output "instance_external_ip" {
  description = "IP externo da instância — use para SSH"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}
