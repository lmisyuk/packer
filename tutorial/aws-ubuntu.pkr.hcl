packer {
    required_plugins {
        amazon = {
            version = "~> 1"
            source = "github.com/hashicorp/amazon"
        }
    }
}

locals {
  current_date = formatdate("DDMMYYYY", timestamp())
  current_time   = formatdate("HHmmSS", timestamp())
}

source "amazon-ebs" "devops" {
  // ami parameters
  // ami_name                    = "lev-amzn2-${local.current_date}-${local.current_time}"
  ami_name                    = "lev-amzn2-{{timestamp}}"
  source_ami                  = "data.amazon-linux-2-ami.basic"
  instance_type               = "t3.micro"
  region                      = "il-central-1"
  skip_create_ami             = true

  // connection parameters
  ssh_username                = "ec2-user"
  ssh_interface               = "public_ip"
  associate_public_ip_address = true
  vpc_filter {
    filters = {
      "tag:Name" = "misyuk-vpc",
      isDefault  = false
    }
  }
  subnet_filter {
    filters = {
      "tag:Name" = "misyuk-subnet-public1-il-central-1a"
    }
  }
}

build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y snapd",
      "sudo snap install microk8s --classic --channel=1.28",
      "microk8s version"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}