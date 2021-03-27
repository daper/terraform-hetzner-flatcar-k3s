locals {
  token_file = "${path.module}/k3s-token.txt"
}

resource "null_resource" "get_token" {
  provisioner "local-exec" {
    connection {
      host = module.control-plane.server-ips[0]
      timeout = "3m"
      user = "core"
    }

    command = "ssh core@${module.control-plane.server-ips[0]} sudo cat /var/lib/rancher/k3s/server/node-token > ${path.module}/k3s-token.txt"
  }

  depends_on = [
    module.control-plane,
    null_resource.k3s,
    null_resource.kubectl_config,
  ]
}

resource "null_resource" "k3s-node-pool" {
  count = length(module.node-pool.server-ips)
  provisioner "remote-exec" {
    connection {
      host = module.node-pool.server-ips[count.index]
      timeout = "3m"
      user = "core"
    }

    inline = [
      "mkdir -p /opt/bin",
      "sudo curl -sfL https://get.k3s.io -o /opt/bin/k3s",
      "sudo chmod +x /opt/bin/k3s",
      "/opt/bin/k3s agent --server https://${module.control-plane.server-ips[0]}:6443 --token ${file(local.token_file)}",
    ]
  }

  depends_on = [
    module.node-pool,
    null_resource.get_token,
  ]
}