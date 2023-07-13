terraform {
  required_version = ">= 0.12.29"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name      = "k8s_vpc"
    Createdby = "Terraform"
  }
}

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id   = aws_vpc.k8s_vpc.id

  tags = {
    Name = "vpc_k8s_igw"
    Createdby = "Terraform"
  }
}

resource "aws_subnet" "k8s_subnet" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = "172.16.0.0/24"
     map_public_ip_on_launch     = true

    tags = {
        Name = "k8s_subnet"
        Createdby = "Terraform"
    }
}

resource "aws_route_table" "k8s_rtb" {
  vpc_id   = aws_vpc.k8s_vpc.id

  # Internet Access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_igw.id
  }

  tags = {
    Name = "k8s_rtb"
    Createdby = "Terraform"
  }
}

resource "aws_route_table_association" "k8s_rta" {
  subnet_id      = aws_subnet.k8s_subnet.id
  route_table_id = aws_route_table.k8s_rtb.id
}

# EC2 instances

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrP1PhlPz+rzC1GBYhVTczaiDSQOjHYkm1u6Os/NjSvH/O08HDpltt0bZkzHLUnw2Tus4G7jEgaOCXFKdXeaoxu8Mu4NcCC8PAvryq0uzsQ/SqBn8v7JMfk9QNjcUzOAwjfOYcHrwpqNHoIPMgXShXHlHkD+SfJm7SwEggpQUOmsjuKR7q7TYfwD1LiK3re0tjZgnyYaaU6ruXI+iCoPAuv5ovFOCABMJ30PIlNZXyCxlRE+ejKt1a3xeQAgT6Dv6HCSuff9taVzyMxOItT3g7t16aDjllK4bZ+v4uJH5ERQkE2zPbM6efl/jrMr/jOWltyjSkNpJuGHW8/lgaiqTUtJysjel1+FwwdIdU3w3s6vlmixVPPrEdzEw4zf2UhwmY10vAxQKOzRb7GcZfCQtY1T7MqgYJ3TAtfpim+ZSzZfjrar3RupHglICR3g4spcRgGVUaxunPSMe22lxz65faM+WaIQ4nhXt4ZpvoixLQpe9WatHPcKfID27siBH1a/2rYCzSMAGRyKZ9ZDLYwKdv1S2dzom4JfhkPnDdt/YCVRHWkm3ErIRZSKhXspahBWbXrEqTl3QWkXbiMLCAO6cHWgusH5l/5ZEM/0DIv8rTjyhhX4/z9m0YqwA8aXsh9pnj2shmxr/LmRkz+TiGcbzd40OmQjjmzBTPbh/BUfC6Gw== garrett.saxton@gsaxton-ltm.internal.salesforce.com"
}

resource "aws_security_group" "k8s_sg" {
  name     = "k8s_sg"
  vpc_id   = aws_vpc.k8s_vpc.id

  # inbound SSH only from my IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  }

  # ICMP access from anywhere
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Milestone 2: allow communication on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_sg"
    Createdby = "Terraform"
  }
}

resource "aws_instance" "k8s_instances" {
  for_each = var.k8s_servers
  # this ami comes from the ACG Building a Kubernetes Cluster lab
  ami                         = "ami-0f64b8476ab820830"
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.k8s_subnet.id
  key_name                    = aws_key_pair.ssh_key.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "${each.value}"
  }
}