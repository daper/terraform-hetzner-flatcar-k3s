resource "helm_release" "external_dns" {
  name       = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name = "aws.credentials.secretKey"
    value = var.aws_route53_secret
  }

  set {
    name = "aws.credentials.accessKey"
    value = var.aws_route53_access
  }

  set {
    name = "policy"
    value = "sync"
  }

  set {
    name = "zoneNameFilters.0"
    value = var.dns_zone_filter
  }

  depends_on = [
    null_resource.kubectl_config,
  ]
}