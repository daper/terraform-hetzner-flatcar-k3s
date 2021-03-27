module "k3s" {
  source = "./modules/k3s"
  aws_route53_access = var.aws_access_token
  aws_route53_secret = var.aws_secret_key
  hcloud_token = var.hcloud_token
  hcloud_ssh_key = "yubi"
  cluster_name = "daper"
  dns_zone_filter = "k8s.daper.io"
}