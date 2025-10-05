# Security Group para o EKS
resource "aws_security_group" "eks" {
  name        = "eks-sg"
  description = "Security group para o cluster EKS"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "eks-sg"
    }
  )
}

# Regras de entrada para o EKS
resource "aws_security_group_rule" "eks_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks.id
  description       = "Permite trafego HTTPS para o cluster EKS"
}

resource "aws_security_group_rule" "eks_ingress_internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks.id
  description       = "Permite trafego interno entre os nos do EKS"
}

# Regras de saída para o EKS
resource "aws_security_group_rule" "eks_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks.id
  description       = "Permite todo o trafego de saida do EKS"
}
