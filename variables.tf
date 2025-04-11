variable "resource_group" {
  type = string
}

variable "regions" {
  type = map(object({
    name           = string
    address_prefix = string
    firewall_rules = list(object({
      name                  = string
      priority              = number
      rule_type             = string
      action                = string
      protocols             = list(string)
      source_addresses      = list(string)
      destination_addresses = list(string)
      destination_ports     = list(string)
    }))
    expressroute = object({
      circuit_name      = string
      location          = string
      bandwidth         = number
      peering_location  = string
      authorization_key = string
    })
  }))
}

variable "vnets" {
  type = map(list(object({
    name           = string
    resource_group = string
  })))
}
variable "deploy_spokes" {
  description = "Flag to control whether to connect spokes"
  type        = bool
  default     = false
}
variable "test_mode" {
  description = "If true, skips ExpressRoute and Spoke VNet deployments for testing"
  type        = bool
  default     = false
}
