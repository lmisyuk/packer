source "amazon-ebs" "devops" {
  // ami parameters
  ami_name                    = "lev-amzn2-${local.current_date}-${local.current_time}"
  // ami_name                    = "lev-amzn2-{{timestamp}}"
  source_ami                  = data.amazon-ami.al2.id
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