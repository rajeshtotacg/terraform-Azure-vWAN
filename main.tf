provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "core" {
  name     = var.resource_group
  location = "West Europe" # Or any central region you're using
}

module "vwan" {
  source           = "./modules/vwan"
  location         = "West Europe"
  resource_group   = var.resource_group
}

module "hubs" {
  for_each               = var.regions
  source                 = "./modules/hub"

  region                 = each.value.name
  resource_group         = var.resource_group
  hub_name               = "hub-${each.key}"
  vwan_id                = module.vwan.vwan_id
  address_prefix         = each.value.address_prefix
  firewall_enabled       = true
  gateway_enabled        = true
  routing_intent_enabled = true
  udr_enabled            = true
  firewall_rules         = each.value.firewall_rules
}

module "expressroutes" {
  for_each = var.test_mode ? var.regions : {}

  source = "./modules/expressroute_mock"

  region             = each.value.name
  circuit_name       = each.value.expressroute.circuit_name
  location           = each.value.expressroute.location
  peering_location   = each.value.expressroute.peering_location
  bandwidth          = each.value.expressroute.bandwidth
  authorization_key  = each.value.expressroute.authorization_key
  resource_group     = var.resource_group
}

module "expressroutes_real" {
  for_each = var.test_mode ? {} : var.regions

  source = "./modules/expressroute"

  region             = each.value.name
  circuit_name       = each.value.expressroute.circuit_name
  location           = each.value.expressroute.location
  peering_location   = each.value.expressroute.peering_location
  bandwidth          = each.value.expressroute.bandwidth
  authorization_key  = each.value.expressroute.authorization_key
  resource_group     = var.resource_group
}

module "spokes" {
  for_each = var.test_mode ? {} : { for k, v in var.vnets : k => v if length(v) > 0 }

  source           = "./modules/spoke"
  region           = var.regions[each.key].name
  resource_group   = var.resource_group
  hub_id           = module.hubs[each.key].hub_id
  vnets            = each.value
}


output "hub_outputs" {
  value = {
    for k, mod in module.hubs :
    k => {
      name    = mod.hub_name
      region  = mod.region
      hub_id  = mod.hub_id
    }
  }
}

output "spoke_outputs" {
  value = {
    for k, mod in module.spokes :
    k => mod.spoke_connections
  }
}
