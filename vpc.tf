resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
    Environment = var.env_prefix
    Project     = "aws-infra"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.vpc_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-rtb" {
  #Take the default route table that AWS created for this VPC and modify it
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  #Anyone from internet → SSH into your server
  ingress {
    from_port =22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = ["YOUR_IP/32"]
  }
  #Anyone → access your application (like Tomcat, Spring Boot)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Anyone in the world can access your server
  }

  #All outbound traffic from your resource to anywhere on the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ALL protocols allowed
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}
