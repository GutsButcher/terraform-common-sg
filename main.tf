# locals
locals {
  egress_rules = {
    description = "Allow all egress/outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# sg1 for ssh
resource "aws_security_group" "ssh" {
  name   = "ssh-ingress"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description = var.ingress_rules_map["ssh"].description
    from_port   = var.ingress_rules_map["ssh"].from_port
    to_port     = var.ingress_rules_map["ssh"].to_port
    protocol    = var.ingress_rules_map["ssh"].protocol
    cidr_blocks = var.ingress_rules_map["ssh"].cidr_blocks
  }
  egress {
    description = var.egress_rules.description
    from_port   = var.egress_rules.from_port
    to_port     = var.egress_rules.to_port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
  }
}

# sg2 for ping
resource "aws_security_group" "ping" {
  name   = "ping-ingress"
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description = var.ingress_rules_map["icmp"].description
    from_port   = var.ingress_rules_map["icmp"].from_port
    to_port     = var.ingress_rules_map["icmp"].to_port
    protocol    = var.ingress_rules_map["icmp"].protocol
    cidr_blocks = var.ingress_rules_map["icmp"].cidr_blocks
  }
  egress {
    description = var.egress_rules.description
    from_port   = var.egress_rules.from_port
    to_port     = var.egress_rules.to_port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
  }
}

# sg3 for http, https
resource "aws_security_group" "http" {
  name   = "http-ingress"
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  dynamic "ingress" {
    for_each = { for k, v in var.ingress_rules_map : k => v if contains(["http", "https"], k) }
    content {
      description = ingress.value.description
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = var.egress_rules.description
    from_port   = var.egress_rules.from_port
    to_port     = var.egress_rules.to_port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
  }
}

# sg4 for db
resource "aws_security_group" "db" {
  name   = "db-ingress"
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  ingress {
    description = var.ingress_rules_map["db"].description
    from_port   = var.ingress_rules_map["db"].from_port
    to_port     = var.ingress_rules_map["db"].to_port
    protocol    = var.ingress_rules_map["db"].protocol
    cidr_blocks = var.ingress_rules_map["db"].cidr_blocks
  }
  egress {
    description = var.egress_rules.description
    from_port   = var.egress_rules.from_port
    to_port     = var.egress_rules.to_port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
  }
}