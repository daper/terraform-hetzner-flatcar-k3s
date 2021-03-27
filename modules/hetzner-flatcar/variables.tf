variable "machines" {
  type        = number
  description = "Number of Control Plane machines to deploy"
  default = 1
}

variable "servers_name" {
  type        = string
  description = "Cluster name used as prefix for the machine names"
}

variable "servers_type" {
  type        = string
  default     = "cx21"
  description = "The server type to rent"
}

variable "datacenter" {
  type        = string
  description = "The region to deploy in"
  default = "fsn1-dc14"
}

variable "ssh_bootstrap_key_name" {
  type = string
  description = "Name of the SSH key saved on hetzner to first bootstrap the machine"
}

variable "ip_range" {
  type = string
  description = "ip range to use for private network"
  default     = "192.168.33.0/24"
}

variable "network_zone" {
  type = string
  description = "network zone to use for private network"
  default     = "eu-central"
}