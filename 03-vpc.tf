resource "aws_vpc" "development" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Development VPC"
    )
  )}"
}

resource "aws_internet_gateway" "development" {
  vpc_id = "${aws_vpc.development.id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Internet Gateway"
    )
  )}"
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.development.id}"
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.development"]

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Public Subnet"
    )
  )}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.development.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.development.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Public Route Table"
    )
  )}"
}

resource "aws_route_table_association" "public-subnet" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
