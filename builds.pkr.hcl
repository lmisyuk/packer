build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum update -y",
      "sudo yum -y install wget",
      "wget http://mirror.centos.org/centos/7/updates/x86_64/Packages/selinux-policy-3.13.1-268.el7_9.2.noarch.rpm",
      "wget http://mirror.centos.org/centos/7/updates/x86_64/Packages/selinux-policy-targeted-3.13.1-268.el7_9.2.noarch.rpm",
      "sudo yum -y install *",
      "sudo yum -y install snapd",
      "sudo systemctl enable --now snapd.socket",
      "sudo ln -s /var/lib/snapd/snap /snap",
      "sudo systemctl restart snapd.seeded.service",
      "sudo snap install microk8s --classic --channel=1.28/stable",
      "$(which microk8s) version"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}