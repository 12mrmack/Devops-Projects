# VPC

resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "App-VPC"
    Project = "assignment04"
    Env     = "dev"
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name    = "App-IGW"
    Project = "assignment04"
  }
}


# SUBNETS

# Public Subnet 1 – ap-south-1a – 10.0.1.0/24
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-Subnet-1"
    Project = "assignment04"
  }
}

# Public Subnet 2 – ap-south-1b – 10.0.2.0/24
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-Subnet-2"
    Project = "assignment04"
  }
}

# App Private Subnet 1 – ap-south-1a – 10.0.3.0/24
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name    = "App-Private-Subnet-1"
    Project = "assignment04"
  }
}

# App Private Subnet 2 – ap-south-1b – 10.0.4.0/24
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name    = "App-Private-Subnet-2"
    Project = "assignment04"
  }
}


# ELASTIC IP + NAT GATEWAY

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name    = "NAT-EIP"
    Project = "assignment04"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name    = "NAT-Gateway"
    Project = "assignment04"
  }

  depends_on = [aws_internet_gateway.igw]
}


# ROUTE TABLES


# ── Public Route Table 

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Public-RT"
    Project = "assignment04"
  }
}

resource "aws_route_table_association" "pub_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ── Private Route Table 

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name    = "Private-RT"
    Project = "assignment04"
  }
}

resource "aws_route_table_association" "priv_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "priv_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}


# NETWORK ACLs


# ── Public NACL 

resource "aws_network_acl" "public_nacl" {
  vpc_id     = aws_vpc.app_vpc.id
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  # Inbound: HTTP
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  # Inbound: HTTPS
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  # Inbound: SSH
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  # Inbound: ephemeral ports
  ingress {
    rule_no    = 130
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound: all
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name    = "Public-NACL"
    Project = "assignment04"
  }
}

# ── Private NACL 

resource "aws_network_acl" "private_nacl" {
  vpc_id     = aws_vpc.app_vpc.id
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  # Inbound: all from VPC CIDR
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }
  # Inbound: ephemeral (return traffic from NAT)
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound: all
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name    = "Private-NACL"
    Project = "assignment04"
  }
}


# SECURITY GROUPS

# ── alb-sg 

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS from internet to ALB"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "OpenSearch Dashboards 5601 from internet"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow opensearch "
    from_port   = 9200
    to_port     = 9200
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
    Name    = "alb-sg"
    Project = "assignment04"
  }
}

# ── bastion-sg 

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from internet to Bastion Host"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name    = "bastion-sg"
    Project = "assignment04"
  }
}

# ── app-sg

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow traffic from ALB and Bastion to app instances and OpenSearch"
  vpc_id      = aws_vpc.app_vpc.id
  
   ingress {
    description     = "OpenSearch REST API 9200 from app-sg"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Port 9200 from Bastion (for curl/testing)
  ingress {
    description     = "OpenSearch REST API 9200 from Bastion"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Port 9300 – OpenSearch node-to-node cluster communication
  ingress {
    description = "OpenSearch node-to-node 9300 within VPC"
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Port 5601 – OpenSearch Dashboards
  ingress {
    description     = "OpenSearch Dashboards 5601 from app-sg"
    from_port       = 5601
    to_port         = 5601
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # SSH from Bastion for maintenance
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "OpenSearch HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app-sg"
    Project = "assignment04"
  }
}


# BASTION HOST  (Public Subnet 1 / ap-south-1a)

resource "aws_instance" "bastion" {
  ami                         = "ami-0388e3ada3d9812da"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "batch34"
  tags = {
    Name    = "Bastion-Host"
    Project = "assignment04"
  }
}


# APPLICATION LOAD BALANCER

resource "aws_lb" "alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name    = "App-ALB"
    Project = "assignment04"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 9200
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Change Target Group to HTTP to match
resource "aws_lb_target_group" "app_tg" {
  name_prefix = "apptg-"          # ← prefix, not fixed name
  port        = 9200
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    path                = "/_cluster/health"
    protocol            = "HTTPS"
    matcher             = "200,401"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Listener
resource "aws_lb_listener" "dashboards_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 5601
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboards_tg.arn
  }
}

# 3. Target group (HTTP, with stickiness — see note below)
resource "aws_lb_target_group" "dashboards_tg" {
  name_prefix = "dastg-"
  port        = 5601
  protocol    = "HTTP"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    path                = "/api/status"
    protocol            = "HTTP"
    matcher             = "200,302,401"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


# LAUNCH TEMPLATE + AUTO SCALING GROUP

resource "aws_launch_template" "app_lt" {
  name_prefix            = "app-LT"
  image_id               = "ami-0388e3ada3d9812da"
  instance_type          = "c7i-flex.large"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  key_name = "batch34" 

  user_data = base64encode(file("./userdata.sh"))


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "App-ASG-Instance"
      Project = "assignment04"
    }
  }

  block_device_mappings {
    device_name = "/dev/sda1"   # Ubuntu root; confirm — some AMIs use /dev/xvda
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tags = {
    Name    = "App-Launch-Template"
    Project = "assignment04"
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns = [
    aws_lb_target_group.app_tg.arn,
    aws_lb_target_group.dashboards_tg.arn,
  ]
  health_check_type   = "ELB"
  health_check_grace_period = 600

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App-ASG-Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "assignment04"
    propagate_at_launch = true
  }
}




# S3 BUCKET for – Terraform Remote State

resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-assignment-bucket"

  tags = {
    Name    = "My-terraform-Assignment-bucket"
    Project = "assignment04"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_block" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# OUTPUTS

output "vpc_id" {
  description = "App VPC ID"
  value       = aws_vpc.app_vpc.id
}

output "alb_dns_name" {
  description = "ALB DNS – use this to reach the app"
  value       = aws_lb.alb.dns_name
}

output "bastion_public_ip" {
  description = "Bastion Host public IP"
  value       = aws_instance.bastion.public_ip
}

output "state_bucket" {
  description = "S3 bucket holding tfstate"
  value       = aws_s3_bucket.tf_state.bucket
}
