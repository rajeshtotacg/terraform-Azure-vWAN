resource "azurerm_express_route_circuit" "this" {
  name                  = var.circuit_name
  location              = var.location
  resource_group_name   = var.resource_group
  service_provider_name = "Equinix"
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }
}

resource "azurerm_express_route_circuit_authorization" "auth" {
  name                        = "${var.circuit_name}-auth"
  express_route_circuit_name = azurerm_express_route_circuit.this.name
  resource_group_name         = var.resource_group
}
