resource "aws_route53_zone" "development" {
  name    = "${var.base_domain_name}"
  comment = "Development DNS"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Development Public DNS",
    )
  )}"
}

resource "aws_route53_record" "public_master" {
  zone_id = "${aws_route53_zone.development.zone_id}"
  name    = "master.${var.base_domain_name}"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_eip.development_eip.public_ip}",
  ]
}

resource "aws_route53_zone" "private" {
  name    = "${var.base_domain_name}.local"
  comment = "Development DNS"

  vpc {
    vpc_id = "${aws_vpc.development.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Development Private DNS",
    )
  )}"
}

resource "aws_route53_record" "private_master" {
  zone_id = "${aws_route53_zone.development.zone_id}"
  name    = "master.${var.base_domain_name}.local"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_instance.development_host.private_ip}",
  ]
}

