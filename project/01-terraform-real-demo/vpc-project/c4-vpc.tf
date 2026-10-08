# 01-VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # aca nos aseguramos que cualquier instancia se creen con su hostname/dns apropiado
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc" })
  # lifecycle {
  #   prevent_destroy = true # el motivo de esto es por que el VPC es el elemento key de nuestra infra.
  # } # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle - manejar el comportamiento de la infra.
}
# 02-Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id # ahora se encuentran asociados asociados.
  tags = merge(var.tags, { Name = "${var.environment_name}-igw" })
}

# 03- Public Subnets
resource "aws_subnet" "public" {
  for_each = { for index, az in local.azs : az => local.public_subnets[index] }
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.environment_name}-public-${each.key}" })
}

# 04- Private Subnets

resource "aws_subnet" "private" {
  for_each = { for index, az in local.azs : az => local.private_subnets[index] }
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  # here we are defining the name
  tags = merge(var.tags, { Name = "${var.environment_name}-private-${each.key}" })
}

# 05 - elastic IP for NAT
resource "aws_eip" "nat" {
  tags = merge(var.tags, { Name = "${var.environment_name}-nat-eip" })
}

# 06 - NAT gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id# here we are looking for the first value
  depends_on = [aws_internet_gateway.igw]
  tags = merge(var.tags, { Name = "${var.environment_name}-nat" })
}

# 07 - Public route table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-public-rt" })
}

# 08 - Public route table association to public subnets

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# 09 - Private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-private-rt" })
}

# 10 - Private route table association to private subnets

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}