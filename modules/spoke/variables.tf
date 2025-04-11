variable "region" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "hub_id" {
  type = string
}

variable "vnets" {
  type = list(object({
    name           = string
    resource_group = string
  }))
}
