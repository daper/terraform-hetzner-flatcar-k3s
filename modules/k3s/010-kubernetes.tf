resource "null_resource" "k3s" {
  count = length(module.control-plane.server-ips)
  provisioner "remote-exec" {
    connection {
      host = module.control-plane.server-ips[count.index]
      timeout = "3m"
      user = "core"
    }

    inline = [
      "curl -sfL https://get.k3s.io | sh -",
    ]
  }

  depends_on = [
    module.control-plane
  ]
}

resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = <<-EOF
      ssh core@${module.control-plane.server-ips[0]} sudo cat /etc/rancher/k3s/k3s.yaml > ${path.module}/kube-config.yaml
      sed -i 's/127.0.0.1:6443/${module.control-plane.server-ips[0]}:6443/g' ${path.module}/kube-config.yaml
    EOF
  }

  depends_on = [null_resource.k3s]
}

resource "null_resource" "csidriver" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml apply -f https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csidriver.yaml"
  }

  depends_on = [
    null_resource.kubectl_config,
  ]
}

resource "null_resource" "csinodeinfo" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml apply -f https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csinodeinfo.yaml"
  }

  depends_on = [
    null_resource.kubectl_config,
  ]
}

resource "null_resource" "hcloud_token" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml -n kube-system create secret generic hcloud --from-literal=token=${var.hcloud_token}"
  }

  depends_on = [
    null_resource.kubectl_config,
  ]
}

resource "null_resource" "hcloud_csi_token" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml -n kube-system create secret generic hcloud-csi --from-literal=token=${var.hcloud_token}"
  }

  depends_on = [
    null_resource.kubectl_config,
  ]
}

resource "null_resource" "hcloudcsi" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml apply -f https://raw.githubusercontent.com/hetznercloud/csi-driver/master/deploy/kubernetes/hcloud-csi.yml"
  }

  depends_on = [
    null_resource.csidriver,
    null_resource.csinodeinfo,
  ]
}

resource "null_resource" "cloud-controller" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${path.module}/kube-config.yaml apply -f https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/master/deploy/ccm.yaml"
  }

  depends_on = [
    null_resource.csidriver,
    null_resource.csinodeinfo,
  ]
}

