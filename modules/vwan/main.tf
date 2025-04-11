resource "azurerm_virtual_wan" "this" {
  name                = "vwan-global"
  location            = var.location
  resource_group_name = var.resource_group
  type                = "Standard"
}

output "vwan_id" {
  value = azurerm_virtual_wan.this.id
}
