data "template_file" "machine-configs" {
  count = var.machines
  template = file("${path.module}/flatcar.yaml.tmpl")

  vars = {
    ssh_key = data.hcloud_ssh_key.first.public_key
    name     = "${var.servers_name}-${count.index}"
  }
}

data "ct_config" "machine-ignitions" {
  count = var.machines
  content  = data.template_file.machine-configs[count.index].rendered
}

data "hcloud_ssh_key" "first" {
  name = var.ssh_bootstrap_key_name
}

resource "hcloud_server" "servers" {
  count = var.machines
  name     = "${var.servers_name}-${count.index}"
  ssh_keys = [data.hcloud_ssh_key.first.id]
  # boot into rescue OS
  rescue = "linux64"
  # dummy value for the OS because Flatcar is not available
  image       = "debian-9"
  server_type = var.servers_type
  datacenter  = var.datacenter

  connection {
    host    = self.ipv4_address
    timeout = "1m"
  }

  provisioner "file" {
    content     = data.ct_config.machine-ignitions[count.index].rendered
    destination = "/root/ignition.json"
  }

  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "curl -fsSLO --retry-delay 1 --retry 60 --retry-connrefused --retry-max-time 60 --connect-timeout 20 https://raw.githubusercontent.com/kinvolk/init/flatcar-master/bin/flatcar-install",
      "chmod +x flatcar-install",
      "./flatcar-install -s -i /root/ignition.json",
    ]
  }
}

resource "null_resource" "first_reboot_servers" {
  count = var.machines

  provisioner "local-exec" {
    command = "hcloud server reboot ${hcloud_server.servers[count.index].name}"
  }

  depends_on = [
    hcloud_server.servers
  ]
}