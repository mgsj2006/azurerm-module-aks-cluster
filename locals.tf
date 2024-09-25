
locals {
  tags = {
    "deployed_by"      = "terraform"
    "environment_type" = var.environment
  }
  region      = lower(replace(var.region, "/\\s+/", ""))
  region_prefix = {
    "brazilsouth"    = "brs"
    "southcentralus" = "scu"
    "eastus"         = "eus"
  }
  zone_id = {
    "brazilsouth"      = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-brs-net-01/providers/Microsoft.Network/privateDnsZones/privatelink.brazilsouth.azmk8s.io"
    "brazil south"     = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-brs-net-01/providers/Microsoft.Network/privateDnsZones/privatelink.brazilsouth.azmk8s.io"
    "southcentralus"   = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-scu-netdr-01/providers/Microsoft.Network/privateDnsZones/privatelink.southcentralus.azmk8s.io"
    "south central us" = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-scu-netdr-01/providers/Microsoft.Network/privateDnsZones/privatelink.southcentralus.azmk8s.io"
    "eastus"           = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-scu-netdr-01/providers/Microsoft.Network/privateDnsZones/privatelink.eastus.azmk8s.io"
    "east us"          = "/subscriptions/8fbc1536-8c19-437c-9ab3-71d5f3fbcb2d/resourceGroups/rg-shd-scu-netdr-01/providers/Microsoft.Network/privateDnsZones/privatelink.eastus.azmk8s.io"
  }
  subnet = element(split("/", var.vnet_subnet_id_nodes), length(split("/", var.vnet_subnet_id_nodes)) - 1)
  vnet   = element(split("/", var.vnet_subnet_id_nodes), length(split("/", var.vnet_subnet_id_nodes)) - 3)
  rg     = element(split("/", var.vnet_subnet_id_nodes), length(split("/", var.vnet_subnet_id_nodes)) - 7)
}
