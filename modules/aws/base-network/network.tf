
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "VPC-${var.environment}" ,
    env = "${var.environment}"
  }
}

resource "aws_subnet" "main" {
  count = "${length(data.aws_availability_zones.all.names)}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet("${aws_vpc.main.cidr_block}","${lookup(var.subnets,"bits")}",count.index)}"
  availability_zone = "${element(data.aws_availability_zones.all.names,count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "SN-${var.environment}-${count.index + 1}",
    env = "${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "IGW-${var.environment}",
    env = "${var.environment}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "RT-${var.environment}",
    env = "${var.environment}"
  }
}

resource "aws_route_table_association" "main" {
  count = "${length(data.aws_availability_zones.all.names)}"
  subnet_id = "${element(aws_subnet.main.*.id,count.index)}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_security_group" "cluster_internal" {
  name = "SG-${var.environment}-cluster_internal"
  description = "Internal cluster rules"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    self = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"] 
    from_port   = 443 
    to_port     = 443 
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80 
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags {
    Name = "SG-${var.environment}-cluster_internal",
    env = "${var.environment}"
  }
}

