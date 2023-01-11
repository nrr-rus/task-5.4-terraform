provider "aws" {
  profile = "second"
  region  = "eu-central-1"
}

resource "aws_instance" "Task_5_Terraform_VM" {
  ami                         = "ami-019a1f8c27ec9d28f"
  instance_type               = "t2.micro"
  availability_zone           = "eu-central-1a"
  key_name                    = "Task-5-keypair"
  associate_public_ip_address = true

  tenancy                = aws_vpc.Task_5_Terraform_VPS.instance_tenancy
  subnet_id              = aws_subnet.Task-5-Terraform-Subnet.id
  vpc_security_group_ids = [aws_security_group.Task-5-Terraform-SG.id]

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  tags = {
    Name = "Task-5-Terraform-VM"
  }
}

resource "aws_vpc" "Task_5_Terraform_VPS" {
  tags = {
    Name = "Task-5-Terraform-VPS"
  }

  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "Task_5_IG" {
  tags = {
    Name = "Task-5-Internet-Gateway"
  }

  vpc_id = aws_vpc.Task_5_Terraform_VPS.id
}

resource "aws_security_group" "Task-5-Terraform-SG" {
  tags = {
    Name = "Task-5-Terraform-SG"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name   = "Task-5-Terrafrom-SG"
  vpc_id = aws_vpc.Task_5_Terraform_VPS.id
}

resource "aws_subnet" "Task-5-Terraform-Subnet" {
  tags = {
    Name = "Task-5-Terraform-Subnet"
  }

  availability_zone                   = "eu-central-1a"
  cidr_block                          = "10.20.100.0/24"
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
  vpc_id                              = aws_vpc.Task_5_Terraform_VPS.id
}

resource "aws_subnet" "Task-5-Terraform-Subnet-2" {
  tags = {
    Name = "Task-5-Terraform-Subnet-2"
  }

  availability_zone                   = "eu-central-1b"
  cidr_block                          = "10.20.200.0/24"
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
  vpc_id                              = aws_vpc.Task_5_Terraform_VPS.id
}

resource "aws_route_table" "Task-5-Terraform-Routes" {
  tags = {
    Name = "Task-5-Terraform-Routes"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Task_5_IG.id
  }

  vpc_id = aws_vpc.Task_5_Terraform_VPS.id
}

resource "aws_route_table_association" "assoc-1" {
  subnet_id      = aws_subnet.Task-5-Terraform-Subnet.id
  route_table_id = aws_route_table.Task-5-Terraform-Routes.id
}

resource "aws_route_table_association" "assoc-2" {
  subnet_id      = aws_subnet.Task-5-Terraform-Subnet-2.id
  route_table_id = aws_route_table.Task-5-Terraform-Routes.id
}

resource "aws_lb" "Task-5-Terrafrom-APP-LB" {
  name               = "Task-5-APP-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Task-5-Terraform-SG.id]
  subnets            = [aws_subnet.Task-5-Terraform-Subnet.id, aws_subnet.Task-5-Terraform-Subnet-2.id]
}
