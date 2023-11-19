build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    inline = [
      "amazon-linux-extras install epel -y",
      "yum update -y",
      "yum -y install snapd",
      "systemctl enable --now snapd.socket",
      "ln -s /var/lib/snapd/snap /snap",
      "systemctl restart snapd.seeded.service",
      "snap install microk8s --classic --channel=1.28/stable",
      "microk8s version"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}