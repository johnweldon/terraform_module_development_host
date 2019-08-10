output "development_host_name" {
  value = "${aws_route53_record.public_master.name}"
}

output "development_host_ip" {
  value = "${aws_eip.development_eip.public_ip}"
}
