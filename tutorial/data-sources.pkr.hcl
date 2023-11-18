data "amazon-ami" "al2" {
    filters = {
        virtualization-type = "hvm"
        name = "amzn2*"
        root-device-type = "ebs"
    }
    owners = ["amazon"]
    most_recent = true
}