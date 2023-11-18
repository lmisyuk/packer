data "amazon-linux-2-ami" "basic" {
    filters = {
        virtualization-type = "hvm"
        name = "amzn2*"
        root-device-type = "ebs"
    }
    owners = ["amazon"]
    most_recent = true
}