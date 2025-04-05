provider "aws" {
     region = "us-east-1"
   }

   resource "aws_instance" "flask_app" {
     ami           = "ami-0c55b159cbfafe1f0" # Uygun bir EC2 AMI ID'si
     instance_type = "t2.micro"

     tags = {
       Name = "FlaskAppInstance"
     }

     user_data = <<-EOF
       #!/bin/bash
       apt update -y
       apt install -y docker.io
       apt install -y docker-compose
       cd /home/ubuntu
       git clone https://github.com/kullanici/arac-kiralama.git
       cd arac-kiralama
       docker-compose up -d
     EOF
   }