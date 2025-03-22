provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "genie" {
  ami           = "ami-0c02fb55956c7d316" # Replace with your region's Ubuntu AMI
  instance_type = "t3.medium"
  key_name      = "genie-key" # Replace with your actual key pair

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git python3 -y",
      "git clone https://github.com/your-org/genie.git",
      "cd genie && chmod +x deploy.sh && ./deploy.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/genie-key.pem") # Replace if different
      host        = self.public_ip
    }
  }

  tags = {
    Name = "GENIE 3.0 EC2"
  }
}
