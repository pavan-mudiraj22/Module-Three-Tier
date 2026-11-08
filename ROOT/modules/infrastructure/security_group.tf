# Bastion Host SG
resource "aws_security_group" "bastion_host" {
  name        = "bastion-host-sg"
  description = "Allow SSH from trusted admin IPs"
  vpc_id      = aws_vpc.three_tier.id

  ingress {
    description = "Allow SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }
}

# ALB Frontend SG
resource "aws_security_group" "alb_frontend" {
  name        = "alb-frontend-sg"
  description = "Allow public HTTP/HTTPS traffic to the frontend ALB"
  vpc_id      = aws_vpc.three_tier.id

  ingress = [
    for port in [80, 443] : {
      description      = "Allow HTTP/HTTPS from public internet"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-frontend-sg"
  }
}

# ALB Backend SG
resource "aws_security_group" "alb_backend" {
  name        = "alb-backend-sg"
  description = "Allow public HTTP/HTTPS traffic to the backend ALB"
  vpc_id      = aws_vpc.three_tier.id

  ingress = [
    for port in [80, 443] : {
      description      = "Allow HTTP/HTTPS from public internet"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-backend-sg"
  }
}

# Frontend Server SG
resource "aws_security_group" "frontend_server" {
  name        = "frontend-server-sg"
  description = "Allow SSH and HTTP traffic from admin IP and ALB"
  vpc_id      = aws_vpc.three_tier.id

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description     = "HTTP from frontend ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-server-sg"
  }
}

# Backend Server SG
resource "aws_security_group" "backend_server" {
  name        = "backend-server-sg"
  description = "Allow SSH and backend traffic from admin IP and ALB"
  vpc_id      = aws_vpc.three_tier.id

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description     = "Backend app traffic from backend ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-server-sg"
  }
}

# Database SG
resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Allow MySQL access only from the backend server"
  vpc_id      = aws_vpc.three_tier.id

  ingress {
    description     = "MySQL/Aurora from backend server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}
