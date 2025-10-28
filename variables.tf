variable "gcp_credentials" {
  description = "Base64-encoded GCP service account key"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "n8n-vpc-network"
  
}

variable "subnetwork_name" {
  description = "Name of the subnetwork"
  type        = string
  default     = "n8n-subnetwork"
}

variable "subnetwork_ip_cidr_range" {
  description = "IP CIDR range for the subnetwork"
  type        = string
  default     = "10.0.1.0/24"
}

variable "firewall_name" {
  description = "Name of the firewall rule"
  type        = string
  default     = "n8n-firewall"  
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
  default     = "n8n-instance"
}

variable "machine_type" {
  description = "Machine type for the Compute Engine instance"
  type        = string
  default     = "e2-medium"
}
