variable "aws_route53_access" {
  type = string
  description = "AWS Route53 Access Token to use for external-dns on kubernetes"
}

variable "aws_route53_secret" {
  type = string
  description = "AWS Route53 Secret Key to use for external-dns on kubernetes"
}

variable "hcloud_token" {
  type = string
  description = "Hetzner API Token"
}

variable "hcloud_ssh_key" {
  type = string
  description = "Hetzner name of the SSH key to use for bootstraping all machines"
}

variable "hcloud_datacenter" {
  type = string
  description = "Hetzner data"
  default = "fsn1-dc14"
}

variable "cluster_name" {
  type = string
  description = "K3S Cluster name"
  default = "k3s-cluster"
}

variable "cluster_control_plane_size" {
  type = number
  description = "Number of nodes to use as control plane. Only 1 allowed for now."
  default = 1
}

variable "cluster_node_pool_size" {
  type = number
  description = "Number of nodes to use as part of the node pool"
  default = 1
}

variable "dns_zone_filter" {
  type = string
  description = "DNS domain name to register services on. Ex: k8s.daper.io"
}

variable "letsencrypt_prod" {
  type = bool
  description = "Wether to use letsencrypt prod or staging ACME servers"
  default = false
}