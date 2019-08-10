resource "aws_security_group" "development-vpc" {
  name        = "development-vpc"
  description = "Default security group"
  vpc_id      = "${aws_vpc.development.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Internal VPC Security Group"
    )
  )}"
}

resource "aws_security_group" "development-public-ingress" {
  name        = "development-public-ingress"
  description = "Security group allowing public ingress to instances, HTTP, HTTPS"
  vpc_id      = "${aws_vpc.development.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Public Ingress"
    )
  )}"
}

resource "aws_security_group" "development-public-egress" {
  name        = "development-public-egress"
  description = "Security group allowing egress to public; HTTP, HTTPS"
  vpc_id      = "${aws_vpc.development.id}"

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Public Egress"
    )
  )}"
}

resource "aws_security_group" "development-ssh" {
  name        = "development-ssh"
  description = "Security group allowing public ingress over SSH"
  vpc_id      = "${aws_vpc.development.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "SSH Access"
    )
  )}"
}
