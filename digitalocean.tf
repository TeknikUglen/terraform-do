terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.28.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_api_token
}

resource "digitalocean_droplet" "web" {
  image              = "debian-11-x64"
  name               = "test-web-vm"
  region             = "ams3"
  size               = "s-1vcpu-512mb-10gb"
  monitoring         = true
	backups            = false
  ipv6               = false
	ssh_keys           = var.do_ssh_keys
  vpc_uuid           = var.do_vpc_uuid
}
