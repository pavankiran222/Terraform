#New AWS VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "terraform_igw"
  }
}

# Create a Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
  tags = {
    Name = "terraform_public_subnet"
  }
}

# Create a Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "terraform_private_subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "terraform_public_rt"
  }
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway in Public Subnet
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "terraform_nat_eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "terraform_nat_gw"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create a Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "terraform_private_rt"
  }
}

# Associate the Route Table with the Private Subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# Create a Security Group for SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
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
    Name = "terraform_allow_ssh"
  }
}

# Create a Key Pair for SSH access
resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform_ssh_key"
  public_key = var.ssh_public_key
}

# Launch an EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0ee4f2271a4df2d7d" # Amazon Linux 2023 AMI in us-east-2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name = "terraform_ec2"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "The public IP address of the EC2 instance"
}

# Output the SSH command
output "ssh_command" {
  value       = "ssh -i ~/.ssh/terraform_key ec2-user@${aws_instance.web.public_ip}"
  description = "Command to SSH into the EC2 instance"
}