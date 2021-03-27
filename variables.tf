variable "aws_access_token" {
  type = string
  description = "AWS Route53 Access Token to use for external-dns on kubernetes"
}

variable "aws_secret_key" {
  type = string
  description = "AWS Route53 Secret Key to use for external-dns on kubernetes"
}

variable "hcloud_token" {
  type = string
  description = "Hetzner API Token"
}