packer {
    required_plugins {
        amazon = {
            version = ">= 0.0.2"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t3.micro"
  region        = "il-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  vpc_filter {
    filters = {
      "tag:Name"  = "misyuk-vpc",
      isDefault   = false
    }
  }
  subnet_filter {
    filters = {
      "tag:NetworkType" = "Public"
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::464929637586:role/github"
    session_name = "packer_session"
  }
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}