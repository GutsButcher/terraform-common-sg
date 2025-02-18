# Terraform AWS Common Security Groups Module

A Terraform module that creates commonly used AWS security groups with predefined rules.

## Features

- Creates four security groups:
  - SSH access (port 22)
  - ICMP/Ping access
  - HTTP/HTTPS access (ports 80, 443)
  - Database access (port 3306)
- All security groups include default egress rules
- Customizable CIDR blocks for each rule
- Create before destroy lifecycle policy

## Usage
AWS access credentials
```bash
export AWS_ACCESS_KEY_ID=<ACCESS-KEY-VALUE>
export AWS_SECRET_ACCESS_KEY=<SECRET-ACCESS-KEY-VALUE>
```
```hcl
module "security_groups" {
  source = "git::https://github.com/gutsbutcher/terraform-common-sg.git"

  vpc_id = "vpc-xxxxxxxx"
}
```

### Using Specific Security Groups

```hcl
resource "aws_instance" "web" {
  # ... other configuration ...

  vpc_security_group_ids = [
    module.security_groups.http_sg_id,
    module.security_groups.ssh_sg_id
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| aws_security_group.ssh | resource |
| aws_security_group.ping | resource |
| aws_security_group.http | resource |
| aws_security_group.db | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The VPC ID where security groups will be created | `string` | n/a | yes |
| ingress_rules_map | Map of ingress rules with configuration | `map(object)` | See below | no |
| egress_rules | Configuration for egress rules | `object` | See below | no |

### Default Ingress Rules

```hcl
ingress_rules_map = {
  ssh = {
    description = "Allow SSH Traffic"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  },
  icmp = {
    description = "Allow ICMP Traffic"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  },
  http = {
    description = "Allow HTTP Traffic"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  },
  https = {
    description = "Allow HTTPS Traffic"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  },
  db = {
    description = "Allow MySQL Traffic"
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Default Egress Rules

```hcl
egress_rules = {
  description = "Allow all egress/outbound traffic"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

## Outputs

| Name | Description |
|------|-------------|
| ssh_sg_id | ID of the SSH security group |
| ping_sg_id | ID of the PING security group |
| http_sg_id | ID of the HTTP/HTTPS security group |
| db_sg_id | ID of the Database security group |

## Examples

### Basic Usage
```hcl
module "security_groups" {
  source = "git::https://github.com/username/terraform-common-sg.git"

  vpc_id = aws_vpc.main.id
}
```

### Custom CIDR Blocks
```hcl
module "security_groups" {
  source = "git::https://github.com/username/terraform-common-sg.git"

  vpc_id = aws_vpc.main.id
  
  ingress_rules_map = {
    ssh = {
      description = "Allow SSH from Internal Network"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.0.0.0/8"]
    }
    # ... other rules ...
  }
}
```

## Security Considerations

- By default, all security groups allow traffic from `0.0.0.0/0` (any IP)
- For production environments, consider restricting CIDR blocks to specific IP ranges
- Database security group should typically be restricted to internal networks
- Consider using security group references instead of CIDR blocks where appropriate