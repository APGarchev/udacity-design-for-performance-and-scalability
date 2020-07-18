provider "aws" {
  profile = var.profile
  region  = var.region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*.*.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
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

resource "aws_instance" "t2_server" {
#   count         = 4
  count         = 1
  subnet_id     = aws_subnet.public.id
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = "${var.region}-key"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]

  tags = {
    Name        = "Udacity T2 (${count.index + 1})"
    Project     = "Udacity"
  }
}

# resource "aws_instance" "m4_server" {
#   count         = 2
#   subnet_id     = aws_subnet.public.id
#   ami           = data.aws_ami.amazon_linux_2.id
#   instance_type = "m4.large"
#   key_name      = "${var.region}-key"
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]

#   tags = {
#     Name        = "Udacity M4 (${count.index + 1})"
#     Project     = "Udacity"
#   }
# }