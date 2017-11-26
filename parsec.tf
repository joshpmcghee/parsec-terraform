# Variables

variable "parsec_authcode" {
  type = "string"
}

variable "aws_cheapest_az" {
  type    = "string"
  default = ""
}

variable "aws_region" {
  type = "string"
}

# Template

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_ami" "parsec" {
  most_recent = true

  filter {
    name   = "name"
    values = ["parsec-g3-ws2016-10"]
  }
}

resource "aws_vpc" "vpc_parsec" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Parsec VPC"
  }
}

resource "aws_subnet" "vpc_parsec_public_subnet" {
  availability_zone       = "${var.aws_cheapest_az}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.vpc_parsec.id}"

  tags = {
    Name = "Parsec VPC Public Subnet"
  }
}

resource "aws_internet_gateway" "vpc_parsec_gateway" {
  vpc_id = "${aws_vpc.vpc_parsec.id}"

  tags {
    Name = "Parsec VPC InternetGateway"
  }
}

resource "aws_route" "vpc_parsec_route_table" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_parsec_gateway.id}"
  route_table_id         = "${aws_vpc.vpc_parsec.main_route_table_id}"
}

resource "aws_route_table_association" "vpc_parsec_subnet_route_table_association" {
  route_table_id = "${aws_vpc.vpc_parsec.main_route_table_id}"
  subnet_id      = "${aws_subnet.vpc_parsec_public_subnet.id}"
}

resource "aws_security_group" "parsec" {
  vpc_id      = "${aws_vpc.vpc_parsec.id}"
  name        = "parsec"
  description = "Allow inbound Parsec traffic and all outbound."

  ingress {
    from_port   = 8000
    to_port     = 8004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5900
    to_port     = 5900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5900
    to_port     = 5900
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8004
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = "${file("user_data.tmpl")}"

  vars {
    authcode = "${var.parsec_authcode}"
  }
}

resource "aws_spot_instance_request" "parsec" {
  spot_price    = "0.7"
  ami           = "${data.aws_ami.parsec.id}"
  subnet_id     = "${aws_subnet.vpc_parsec_public_subnet.id}"
  instance_type = "g2.2xlarge"

  tags {
    Name = "ParsecServer"
  }

  root_block_device {
    volume_size = 30
  }

  ebs_block_device {
    volume_size = 100
    volume_type = "gp2"
    device_name = "xvdg"
  }

  user_data = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids      = ["${aws_security_group.parsec.id}"]
  associate_public_ip_address = true
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "aws_subnet" {
  value = "${aws_subnet.vpc_parsec_public_subnet.id}"
}

output "aws_vpc" {
  value = "${aws_vpc.vpc_parsec.id}"
}
