provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name           = "Udacity VPC"
    Project        = "Udacity"
  }
}

resource "aws_subnet" "public" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Udacity Public Subnet"
    Project     = "Udacity"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id        = aws_vpc.main.id

  tags = {
    Name        = "Udacity IGW"
    Project     = "Udacity"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "Udacity Route Table"
    Project     = "Udacity"
  }
}

resource "aws_main_route_table_association" "rta" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH Inbound Traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Udacity Allow SSH SG"
    Project     = "Udacity"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP Inbound Traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Udacity Allow HTTP SG"
    Project     = "Udacity"
  }
}