resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "vpc"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "public-subnet-${count.index + 1}"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_subnet" "eks_private" {
  count             = length(var.eks_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.eks_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name                              = "eks-private-subnet-${count.index + 1}"
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

resource "aws_subnet" "rds_private" {
  count             = length(var.rds_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.rds_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "rds-private-subnet-${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "igw"
    }
  )
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnets)
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "nat-gw-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "public-rt"
    }
  )
}

resource "aws_route_table" "eks_private" {
  count  = length(var.eks_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "eks-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table" "rds_private" {
  count  = length(var.rds_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "rds-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "eks_private" {
  count          = length(var.eks_private_subnets)
  subnet_id      = aws_subnet.eks_private[count.index].id
  route_table_id = aws_route_table.eks_private[count.index].id
}

resource "aws_route_table_association" "rds_private" {
  count          = length(var.rds_private_subnets)
  subnet_id      = aws_subnet.rds_private[count.index].id
  route_table_id = aws_route_table.rds_private[count.index].id
} 