# 01-VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # aca nos aseguramos que cualquier instancia se creen con su hostname/dns apropiado
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc" })
  lifecycle {
    prevent_destroy = true # el motivo de esto es por que el VPC es el elemento key de nuestra infra.
  } # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle - manejar el comportamiento de la infra.
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
