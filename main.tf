/*
provider "aws" {
  region = var.region
  access_key = "<YOUR ACCESS KEY HERE>"
  secret_key = "<YOUR SECRET KEY HERE>"
}
*/

provider "aws" {
region = var.region
shared_credentials_file = "~/.aws/credentials"
}

// MASTER VM
resource "aws_instance" "master" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro" 
  tags = {
      Name = "${var.prefix}-master-01"
    }
  key_name = var.key
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  /*
  user_data = <<-EOF
                #!/bin/bash
                echo "THIS IS OUR MASTER INSTANCE - ENDAVA Argentina INTERNSHIP 2021" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
  */
  user_data = file("./scripts/ubuntu-pre-reqs.sh")
}
// WORKER VMs
resource "aws_instance" "worker" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  tags = {
      Name = "${var.prefix}-worker-01"
    }
  key_name = var.key
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  /*
  user_data = <<-EOF
                #!/bin/bash
                echo "THIS IS OUR WORKER NODE - ENDAVA Argentina INTERNSHIP 2021" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
  */
  user_data = file("./scripts/ubuntu-pre-reqs.sh")
}
resource "aws_security_group" "websg" {
  name = "web-sg01"
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  //For 22 ssh
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  // Outbound Rules 
  egress {
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
}


output "instance_ips_master" {
  value = aws_instance.master.public_ip
}

output "instance_ips_worker" {
  value = aws_instance.worker.public_ip
}

