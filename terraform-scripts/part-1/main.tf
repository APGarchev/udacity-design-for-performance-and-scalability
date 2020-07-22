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

data "aws_vpc" "main" {
  tags = {
    Name           = "Udacity VPC"
    Project        = "Udacity"
  }
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name        = "Udacity Public Subnet"
    Project     = "Udacity"
  }
}

data "aws_security_group" "allow_ssh" {
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name        = "Udacity Allow SSH SG"
    Project     = "Udacity"
  }
}

data "aws_security_group" "allow_http" {
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name        = "Udacity Allow HTTP SG"
    Project     = "Udacity"
  }
}

resource "aws_instance" "t2_server" {
  count         = 4
  subnet_id     = data.aws_subnet.public.id
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = "${var.region}-key"
  vpc_security_group_ids = [data.aws_security_group.allow_ssh.id, data.aws_security_group.allow_http.id]

  tags = {
    Name        = "Udacity T2 (${count.index + 1})"
    Project     = "Udacity"
  }
}

resource "aws_instance" "m4_server" {
  count         = 2
  subnet_id     = aws_subnet.public.id
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "m4.large"
  key_name      = "${var.region}-key"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name        = "Udacity M4 (${count.index + 1})"
    Project     = "Udacity"
  }
}