build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    environment_vars = [
      "user=${local.user}"
    ]
    scripts = [
      "${path.root}/scripts/init.sh"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}