variable "main_vpc_id" {
  type = string
}

variable "second_vpc_id" {
  type = string
}

variable "main_vpc_subnet_ids" {
  type = list(string)
}

variable "second_vpc_subnet_ids" {
  type = list(string)
}
