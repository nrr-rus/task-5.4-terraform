output "EC2_instance_IP" {
  value = aws_instance.Task_5_Terraform_VM.public_ip
}

output "EC2_instance_DNS_record" {
  value = aws_instance.Task_5_Terraform_VM.public_dns
}
