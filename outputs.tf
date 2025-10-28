output "n8n_instance_ip" {
  description = "The public IP address of the n8n instance"
  value       = google_compute_instance.n8n_instance.network_interface[0].access_config[0].nat_ip
  
}