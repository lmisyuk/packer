build {
  name    = "trackeriq"
  sources = [
    "source.amazon-ebs.devops"
  ]
  provisioner "shell" {
    environment_vars = [
      "user=${local.user}"
    ]
    execute_command = "echo trackeriq | {{ .Vars }} sudo -EHS bash '{{ .Path }}'"
    scripts = [
      "${path.root}/scripts/init.sh"
    ]
  }
  post-processor "manifest" {
    output = "amazon-linux-2-ami.json"
  }
}