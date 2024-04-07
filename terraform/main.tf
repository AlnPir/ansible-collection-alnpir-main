terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    ansible = {
      version = "~> 1.2.0"
      source  = "ansible/ansible"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# Create a Security Group for an EC2 instance 
resource "aws_security_group" "test_instance" {
  name = "terraform-test-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_instance" "server1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["${aws_security_group.test_instance.id}"]
  user_data              = data.cloudinit_config.cloud_init.rendered
}

resource "ansible_host" "server1" {
  name   = "${aws_instance.server1.public_ip}.sslip.io"
  groups = ["servers"]

  variables = {
    ansible_user = "ansible"
    ansible_host = aws_instance.server1.public_ip
  }
}

resource "ansible_group" "web" {
  name     = "aws"
  children = ["server"]

  variables = {
    ansible_ssh_private_key_file = "~/.ssh/id_ed25519"
  }
}