packer {
    required_plugins {
        amazon = {
            version = "~> 1"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "lev-amzn2"
  instance_type = "t3.micro"
  region        = "il-central-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.0.20231101.0-x86_64-ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  ssh_interface = "public_ip"
  associate_public_ip_address = true
  vpc_filter {
    filters = {
      "tag:Name"  = "misyuk-vpc",
      isDefault   = false
    }
  }
  subnet_filter {
    filters = {
      "tag:Name" = "misyuk-subnet-public1-il-central-1a"
    }
  }
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}