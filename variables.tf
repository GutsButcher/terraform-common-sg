# Must specified variable
variable "vpc_id" {
  description = "The VPC ID"
  type = string
}

###############################################################################################################
variable "egress_rules" {
  
    default = {
        description = "Allow all egress/outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# Create a map of common ingress rules
variable "ingress_rules_map" {

    type = map(object({
        description = string
        protocol = string
        from_port = number
        to_port = number
        cidr_blocks = list(string)
    }))

    description = "map of common ingress rules (ssh, icmp, http, https, db, etc)"
    default = {
        ssh = {
            description = "Allow SSH Traffic"
            protocol = "tcp"
            from_port = 22
            to_port = 22
            cidr_blocks = ["0.0.0.0/0"]
        },
        icmp = {
            description = "Allow ICMP Traffic"
            protocol = "icmp"
            from_port = -1
            to_port = -1
            cidr_blocks = ["0.0.0.0/0"]
        },
        http = {
            description = "Allow HTTP Traffic"
            protocol = "tcp"
            from_port = 80
            to_port = 80
            cidr_blocks = ["0.0.0.0/0"]
        },
        https = {
            description = "Allow HTTPS Traffic"
            protocol = "tcp"
            from_port = 443
            to_port = 443
            cidr_blocks = ["0.0.0.0/0"]
        },
        db = {
            description = "Allow MySQL Traffic"
            protocol = "tcp"
            from_port = 3306
            to_port = 3306
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}