terraform {
  required_version = "1.6.2"
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.57"

    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.2"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
  }
}

provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

data "exoscale_template" "my_template" {
  zone = "ch-gva-2"
  name = "Linux Ubuntu 22.04 LTS 64-bit"
}

data "cloudinit_config" "cloud_init" {
  part {
    filename     = "cloud-init.yml"
    content_type = "text/cloud-config"
    content = templatefile("scripts/cloud-init.yml", {
      sshkey = var.sshkey
    })
  }
}

resource "exoscale_security_group" "common_security_group" {
  name = "common-security-group"
}

resource "exoscale_security_group_rule" "ssh_ipv4" {
  security_group_id = exoscale_security_group.common_security_group.id
  description       = "SSH (IPv4)"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 22
  end_port          = 22
  cidr              = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "http_ipv4" {
  security_group_id = exoscale_security_group.common_security_group.id
  description       = "HTTP (IPv4)"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 8080
  end_port          = 8080
  cidr              = "0.0.0.0/0"
}

resource "exoscale_compute_instance" "server1" {
  zone               = "ch-gva-2"
  name               = "my-instance"
  security_group_ids = [exoscale_security_group.common_security_group.id]
  user_data          = data.cloudinit_config.cloud_init.rendered
  template_id        = data.exoscale_template.my_template.id
  type               = var.exoscale_compute_instance_type
  disk_size          = var.exoscale_compute_instance_disk_size
}

resource "ansible_host" "server1" {
  name   = "${exoscale_compute_instance.server1.public_ip_address}.sslip.io"
  groups = ["servers"]

  variables = {
    ansible_user = "ansible"
    ansible_host = exoscale_compute_instance.server1.public_ip_address
  }
}

resource "ansible_group" "exoscale" {
  name     = "exoscale"
  children = ["server"]

  variables = {
    ansible_ssh_private_key_file = "~/.ssh/id_ed25519"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}