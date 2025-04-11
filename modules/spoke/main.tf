data "azurerm_virtual_network" "existing" {
  for_each            = { for v in var.vnets : v.name => v }

  name                = each.value.name
  resource_group_name = each.value.resource_group
}

resource "azurerm_virtual_hub_connection" "spoke_connection" {
  for_each                  = data.azurerm_virtual_network.existing

  name                      = "${each.key}-to-hub"
  virtual_hub_id            = var.hub_id
  remote_virtual_network_id = each.value.id
  internet_security_enabled = true
}
