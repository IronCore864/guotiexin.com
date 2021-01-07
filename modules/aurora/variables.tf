variable "db_subnet_ids" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "allow_inbound_cidrs" {
  type = list(any)
}
