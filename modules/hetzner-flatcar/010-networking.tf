resource "hcloud_network" "net" {
  name     = var.servers_name
  ip_range = var.ip_range
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.net.id
  type         = "server"
  network_zone = var.network_zone
  ip_range     = var.ip_range
}

resource "hcloud_server_network" "servers" {
  count     = var.machines
  server_id = element(hcloud_server.servers.*.id, count.index)
  subnet_id = hcloud_network_subnet.subnet.id
}

# resource "hcloud_load_balancer" "load_balancer" {
#   name               = "${var.cluster_name}-lb"
#   load_balancer_type = "lb11"
#   location           = "nbg1"

#   labels = {
#     "cluster_name" = var.cluster_name
#     "role"                 = "lb"
#   }

#   depends_on = [
#     hcloud_server_network.servers,
#     hcloud_network_subnet.subnet
#   ]
# }

# resource "hcloud_load_balancer_network" "load_balancer" {
#   load_balancer_id = hcloud_load_balancer.load_balancer.id
#   subnet_id        = hcloud_network_subnet.subnet.id
# }

# resource "hcloud_load_balancer_target" "load_balancer_target" {
#   count            = var.machines
#   type             = "server"
#   load_balancer_id = hcloud_load_balancer.load_balancer.id
#   server_id        = element(hcloud_server.control_plane.*.id, count.index)
#   use_private_ip   = true
#   depends_on = [
#     hcloud_server_network.servers,
#     hcloud_load_balancer_network.load_balancer
#   ]
# }

# resource "hcloud_load_balancer_service" "load_balancer_service" {
#   load_balancer_id = hcloud_load_balancer.load_balancer.id
#   protocol         = "tcp"
#   listen_port      = 6443
#   destination_port = 6443
# }