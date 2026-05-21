# Provision an EC2 instance on AWS Platform

terraform {
  required_providers {
    aws = {
        version = "~>6.0"
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "simple-server" {
    ami = "ami-09ed39e30153c3bf9"
    instance_type = "t3.micro"
    availability_zone = "ap-south-1a"
    key_name = "harsha-server"
    vpc_security_group_ids = [ aws_security_group.ss-sec-grp.id ]

    provisioner "local-exec" {
        command = <<EOT
        sudo sleep 120
        sudo ssh-keygen -R ${self.public_ip}
        sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.public_ip}, playbook.yaml -u ec2-user --private-key /home/ec2-user/.keys/harsha-server.pem
    EOT
    }
}

resource "aws_security_group" "ss-sec-grp" {
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

output "simple-server-public-ip" {
    value = aws_instance.simple-server.public_ip
}