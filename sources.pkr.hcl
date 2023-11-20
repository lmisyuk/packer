source "amazon-ebs" "devops" {
  // ami parameters
  ami_name                    = "lev-amzn2-{{timestamp}}"
  source_ami                  = data.amazon-ami.al2.id
  instance_type               = "t2.medium"
  region                      = "il-central-1"
  skip_create_ami             = true

  // mount settings
  launch_block_device_mappings {
    device_name               = "/dev/xvda"
    volume_size               = "25"
    volume_type               = "gp3"
    delete_on_termination     = true
  }
  launch_block_device_mappings {
    device_name               = "/dev/sdb"
    volume_size               = "700"
    volume_type               = "gp3"
    delete_on_termination     = true
  }

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