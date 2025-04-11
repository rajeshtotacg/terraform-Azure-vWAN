resource "azurerm_virtual_hub" "this" {
  name                = var.hub_name
  location            = var.region
  resource_group_name = var.resource_group
  virtual_wan_id      = var.vwan_id
  address_prefix      = var.address_prefix
}

resource "azurerm_firewall_policy" "this" {
  count               = var.firewall_enabled ? 1 : 0
  name                = "${var.hub_name}-fw-policy"
  location            = var.region
  resource_group_name = var.resource_group
}

resource "azurerm_firewall_policy_rule_collection_group" "rules" {
  count              = var.firewall_enabled ? 1 : 0
  name               = "${var.hub_name}-netrules"
  priority           = 100
  firewall_policy_id = length(azurerm_firewall_policy.this) > 0 ? azurerm_firewall_policy.this[0].id : null

  network_rule_collection {
    name     = "default-netrules"
    priority = 100
    action   = "Allow"

    dynamic "rule" {
      for_each = var.firewall_rules
      content {
        name                  = rule.value.name
        protocols             = rule.value.protocols
        source_addresses      = rule.value.source_addresses
        destination_addresses = rule.value.destination_addresses
        destination_ports     = rule.value.destination_ports
      }
    }
  }
}

resource "azurerm_virtual_hub_route_table" "udr" {
  count          = var.udr_enabled ? 1 : 0
  name           = "defaultRouteTable"
  virtual_hub_id = azurerm_virtual_hub.this.id
  labels         = ["Default"]
}