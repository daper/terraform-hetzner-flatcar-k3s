terraform {
  required_version = ">= 0.13"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.23.0"
    }

    ct = {
      source  = "poseidon/ct"
      version = "0.7.1"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }

    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

provider "docker" {
  host = "ssh://core@${hcloud_server.machine[0].ipv4_address}:22"
}