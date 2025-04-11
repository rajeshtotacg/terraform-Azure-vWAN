variable "region"           { type = string }
variable "resource_group"   { type = string }
variable "hub_name"         { type = string }
variable "vwan_id"          { type = string }
variable "address_prefix"   { type = string }
variable "firewall_enabled" { type = bool }
variable "gateway_enabled"  { type = bool }
variable "routing_intent_enabled" { type = bool }
variable "udr_enabled"      { type = bool }

variable "firewall_rules" {
  type = list(object({
    name                  = string
    priority              = number
    rule_type             = string
    action                = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = list(string)
    destination_ports     = list(string)
  }))
}
