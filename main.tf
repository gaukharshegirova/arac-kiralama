terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t3a.medium"
  key_name = "firstpem"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data =  <<-EOF
          #! /bin/bash
          curl -fsSL https://get.docker.com -o get-docker.sh
          sh get-docker.sh
          sudo groupadd docker
          sudo usermod -aG docker ubuntu
          newgrp docker
          cd /home/ubuntu   
          git clone https://github.com/gaukharshegirova/arac-kiralama.git  
          cd /home/ubuntu/arac-kiralama
          docker compose up -d
          EOF
  tags = {
    Name = "Techpro Rental Car"
  }
}

locals {

  secgr-dynamic-ports=[22,80,8000,443,5000]  
}


resource "aws_security_group" "allow_tls" {
  name        = "techpro-rental-car"
  description = "Allow TLS inbound traffic and all outbound traffic"
dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "techpro-rental-car"
  }
}