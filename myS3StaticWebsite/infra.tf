resource "aws_vpc" "main_vpc" { 
     cidr_block = "10.0.0.0/16"
     tags = { Name = "starksVPC" } 
    }
 
resource "aws_subnet" "main_subnet" {
     vpc_id = aws_vpc.main_vpc.id 
     cidr_block = "10.0.1.0/24" 
     availability_zone = "us-east-1a" 
     tags = { Name = "main-subnet" } 
     }
 
resource "aws_internet_gateway" "main_igw" {
     vpc_id = aws_vpc.main_vpc.id
      tags = { Name = "main-igw" } 
      }

resource "aws_route_table" "main_route_table" {
vpc_id = aws_vpc.main_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.main_igw.id
  }
 
  tags = {
    Name = "starksRouteTable"
  }
}
 
resource "aws_route_table_association" "main_subnet_association" {
subnet_id = aws_subnet.main_subnet.id
route_table_id = aws_route_table.main_route_table.id
}
 
resource "aws_security_group" "jenkins_sg" {
     vpc_id = aws_vpc.main_vpc.id 
     name   = "jenkins-sg"
 
    ingress { 
        description = "Allow SSH" 
        from_port   = 22 
        to_port     = 22 
        protocol    = "tcp" 
        cidr_blocks = ["0.0.0.0/0"] 
        }
 
    ingress { 
        description = "Allow Jenkins" 
        from_port   = 8080 
        to_port     = 8080 
        protocol    = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
         }
 
    egress { 
        from_port   = 0 
        to_port     = 0 
        protocol    = "-1" 
        cidr_blocks = ["0.0.0.0/0"] 
        }
 
    tags = { 
        Name = "jenkins-security-group" } 
        }
 
resource "aws_instance" "jenkins_instance" {
     ami = "ami-0f88e80871fd81e91" # Amazon Linux 2 AMI (example) 
     instance_type = "t3.medium"
     key_name      = "Starkss"
     subnet_id = aws_subnet.main_subnet.id 
     security_groups = [aws_security_group.jenkins_sg.id]
     associate_public_ip_address = true
 
    root_block_device { 
        volume_size = 64 
        volume_type = "gp3" 
        }
 
    tags = { 
        Name = "StarksInstance" 
        } 

    user_data = <<-EOF
                #!/bin/bash
                sudo dnf update -y
                sudo dnf install -y java-17-amazon-corretto wget git
                sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
                sudo dnf clean all
                sudo dnf makecache
                sudo dnf install -y --nogpgcheck jenkins
                sudo systemctl enable jenkins
                sudo systemctl start jenkins
                EOF

}

output "public_ip" {
  value = aws_instance.jenkins_instance.public_ip
  description = "The public IP address of the Jenkins server"  
}