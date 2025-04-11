output "hub_name" {
  value = var.hub_name
}

output "region" {
  value = var.region
}

output "hub_id" {
  value = azurerm_virtual_hub.this.id
}
