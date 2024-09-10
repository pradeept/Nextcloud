terraform {
  required_providers {
    digitalocean = {
        source  = "digitalocean/digitalocean"
        version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_project" "project" {
  name = var.project_name
}

data "digitalocean_ssh_key" "ssh-key" {
  name = "Pradeep Tarakar"
}

resource "digitalocean_droplet" "server-instance" {
  name = var.instance_name
  ssh_keys = [data.digitalocean_ssh_key.ssh-key.id]
  image = var.image
  size = var.instance_size
  region = var.instance_region
}
# resource "digitalocean_project_resources" "project-allocation" {
#   project = data.digitalocean_project.project.id
#   resources = [ digitalocean_droplet.server-instance.urn ]
# }

resource "digitalocean_record" "nextcloud-domain-mapping" {
  domain = "sirpi.co.in"
  type   = "A"
  name   = var.subdomain_name
  value  = digitalocean_droplet.server-instance.ipv4_address
  ttl = 369
  provisioner "local-exec" {
    command = "sleep 20"
  }
  provisioner "local-exec" {
    command = " ansible-playbook -i ${digitalocean_droplet.server-instance.ipv4_address}, --ssh-extra-args='-o StrictHostKeyChecking=no' -e 'droplet_id=${digitalocean_droplet.server-instance.id}' -e 'do_pat=${var.do_token}' site.yaml"
    working_dir = "${path.module}/ansible"
  }
}

