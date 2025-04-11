output "spoke_connections" {
  value = {
    for k, conn in azurerm_virtual_hub_connection.spoke_connection :
    k => {
      hub_id     = conn.virtual_hub_id
      vnet_id    = conn.remote_virtual_network_id
      conn_name  = conn.name
    }
  }
}
