data "azurerm_subnet" "subnetaks" {
  name                 = local.subnet
  virtual_network_name = local.vnet
  resource_group_name  = local.rg
}
