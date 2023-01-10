provider "aws" {
  profile = "second"
  region  = "eu-central-1"
}

resource "aws_instance" "Task_5_Terraform_VM" {
  ami                         = "ami-0be7337f9433ddcb8"
  instance_type               = "t2.micro"
  availability_zone           = "eu-central-1a"
  key_name                    = "Task-5-keypair"
  associate_public_ip_address = true
  tenancy                     = aws_vpc.Task_5_Terraform_VPS.instance_tenancy

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

  cidr_block         = "10.20.0.0/16"
  enable_dns_support = true
  instance_tenancy   = "default"
}
