module "control-plane" {
  source = "../hetzner-flatcar"
  datacenter = var.hcloud_datacenter
  ssh_bootstrap_key_name = var.hcloud_ssh_key
  servers_name = "${var.cluster_name}-control-plane"
  machines = var.cluster_control_plane_size
}

module "node-pool" {
  source = "../hetzner-flatcar"
  datacenter = var.hcloud_datacenter
  ssh_bootstrap_key_name = var.hcloud_ssh_key
  servers_name = "${var.cluster_name}-node"
  machines = var.cluster_node_pool_size
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

locals {
  kubectx = "default"
  kubeconfig_path = "${path.module}/kube-config.yaml"
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
    config_context = local.kubectx
  }
}