# main vpc
variable "main_vpc_name" {
  type    = string
  default = "main"
}

variable "main_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "main_vpc_public_subnets" {
  type = map(any)
  default = {
    "eu-central-1a" = "10.0.1.0/24"
    "eu-central-1b" = "10.0.2.0/24"
    "eu-central-1c" = "10.0.3.0/24"
  }
}

variable "main_vpc_private_subnets" {
  type = map(any)
  default = {
    "eu-central-1a" = "10.0.11.0/24"
    "eu-central-1b" = "10.0.12.0/24"
    "eu-central-1c" = "10.0.13.0/24"
  }
}

# r53
variable "zone_name" {
  type    = string
  default = "guotiexin.com"
}

# other modules
variable "eks_oidc_provider_url" {
  type = string
}

variable "eks_alb_arn" {
  type = string
}
