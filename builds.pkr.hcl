build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    inline = [
      // "sudo yum update -y",
      "sudo yum install -y snapd",
      "sudo snap install microk8s --classic --channel=1.28",
      "microk8s version"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}