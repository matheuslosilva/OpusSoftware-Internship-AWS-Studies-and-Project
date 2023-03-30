# Criação da VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}

# Criação da Subnet privada
resource "aws_subnet" "privateSubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "privateSubnet"
  }
}

resource "aws_subnet" "privateSubnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "privateSubnet"
  }
}

# Criação da Subnet Pública
resource "aws_subnet" "publicSubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "publicSubnet"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "myvpcIgw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpcIgw"
  }
}

# Criação da Tabela de Roteamento
resource "aws_route_table" "myvpcRtIgw" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpcIgw.id
  }

  tags = {
    Name = "myvpcRtIgw"
  }
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "publicSubnetAssociation" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.myvpcRtIgw.id
}

resource "aws_eip" "eipRP" {
  instance = aws_instance.reverseProxyEC2Instance.id
  vpc = true
}

resource "aws_eip" "eipNAT" {
  vpc = true
  depends_on = [aws_internet_gateway.myvpcIgw]
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eipNAT.id
    subnet_id = aws_subnet.publicSubnet.id
}

# Criação da Tabela de Roteamento
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "privateNatRoute"
  }
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "privateSubnetAssociation" {
  subnet_id      = aws_subnet.privateSubnet.id
  route_table_id = aws_route_table.privateRT.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "privateSubnetAssociation2" {
  subnet_id      = aws_subnet.privateSubnet2.id
  route_table_id = aws_route_table.privateRT.id
}

