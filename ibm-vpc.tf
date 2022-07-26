# VPC RESOURCE

resource "aws_vpc" "ibm_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "ibm vpc"
  }
}


# INTERNETGATEWAY

resource "aws_internet_gateway" "ibm_igw" {
  vpc_id = aws_vpc.ibm_vpc.id
  tags = {
    Name = "ibm igw"
  }
}

# PUBLIC SUBNET IBM

resource "aws_subnet" "ibm_public_sn" {
  vpc_id = aws_vpc.ibm_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "ibm public sn"
  }
}


# create private  subnet

resource "aws_subnet" "ibm_private_sn" {
  vpc_id = aws_vpc.ibm_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "ibm private sn"
  }
}

#create route table

resource "aws_route_table" "ibm_public_rt" {
  vpc_id = aws_vpc.ibm_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm_igw.id
   }
  tags = {
    Name = "ibm public rt"
   }
}





# create a private route table

resource "aws_route_table" "ibm_private_rt" {
  vpc_id = aws_vpc.ibm_vpc.id
  tags = {
  Name = "ibm private ibm"
  }
}


# subnet association public

resource "aws_route_table_association" "ibm_public_sn_asso" {
  subnet_id = aws_subnet.ibm_public_sn.id
  route_table_id = aws_route_table.ibm_public_rt.id
}

# private subnet association

resource "aws_route_table_association" "ibm_private_sn_asso" {
  subnet_id = aws_subnet.ibm_private_sn.id
  route_table_id = aws_route_table.ibm_private_rt.id
}
