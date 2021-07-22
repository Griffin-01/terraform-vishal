provider "aws" {
region = "us-east-1"
access_key = "AKIAU5DY6IBQTNU6BY53" 
secret_key = "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"
}


resource "aws_instance" "web" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  key_name      = "safe"
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]
  tags = {
    Name = "safe-security-internship"
  }
  
}

resource "null_resource" "copy_execute" {
  
    connection {
    type = "ssh"
    host = aws_instance.web.public_ip
    user = "ubuntu"
    private_key = file("safe.pem")
    }

 
  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }
  
  provisioner "file" {
    source      = "test.sh"
    destination = "/tmp/test.sh"
  }

   provisioner "remote-exec" {
    inline = [
      "wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin && export PATH=$PATH:/home/ubuntu/go/bin",
      "source ~/.profile",
      "sudo chmod 777 /tmp/install.sh",
      "sudo chmod 777 /tmp/test.sh",
      "bash /tmp/install.sh",
      "bash /tmp/test.sh",
    ]
  }
  
  depends_on = [ aws_instance.web ]
  
  }

resource "aws_security_group" "webSG" {
  name        = "webSG"
  description = "Allow ssh  inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
}