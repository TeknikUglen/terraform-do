output "instance_id" {
  description = "ID of the DO droplet"
  value       = digitalocean_droplet.web.id
}

output "instance_public_ip" {
  description = "Public IP address of the DO droplet"
  value       = digitalocean_droplet.web.ipv4_address
}

