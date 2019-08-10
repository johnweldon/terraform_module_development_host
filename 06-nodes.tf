resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "setup-development-host" {
  template = "${file("${path.module}/scripts/setup-host.sh")}"

  vars = {
  }
}

data "template_file" "chezmoi-config" {
  template = "${file("${path.module}/scripts/chezmoi.yaml")}"

  vars = {
    email_address = "${var.email_address}"
    display_name  = "${var.display_name}"
    time_zone     = "${var.time_zone}"
    public_key    = "${aws_key_pair.keypair.public_key}"
    private_key   = "${file("${var.private_key_path}")}"
    ssh_config    = "${var.ssh_config}"
  }
}


data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  # get common user_data
  part {
    filename     = "chezmoi.yaml"
    content_type = "text/part-handler"
    content      = "${data.template_file.chezmoi-config.rendered}"
  }

  # get master user_data
  part {
    filename     = "setup-host.sh"
    content_type = "text/part-handler"
    content      = "${data.template_file.setup-development-host.rendered}"
  }

}

resource "aws_eip" "development_eip" {
  instance = "${aws_instance.development_host.id}"
  vpc      = true
}

resource "aws_instance" "development_host" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.amisize}"
  user_data     = "${data.template_cloudinit_config.master.rendered}"
  subnet_id     = "${aws_subnet.public-subnet.id}"

  vpc_security_group_ids = [
    "${aws_security_group.development-vpc.id}",
    "${aws_security_group.development-ssh.id}",
    "${aws_security_group.development-public-ingress.id}",
    "${aws_security_group.development-public-egress.id}",
  ]

  root_block_device {
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Development Host"
    )
  )}"
}
