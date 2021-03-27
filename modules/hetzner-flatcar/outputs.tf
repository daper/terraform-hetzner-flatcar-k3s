output "server-ips" {
  value = hcloud_server.servers.*.ipv4_address
}