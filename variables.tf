variable "name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "region" {
  type        = string
  default     = "Brazil South"
  description = "Region of the world where the resource will be provisioned."
  validation {
    condition     = contains(["brazil south", "south central us", "brazilsouth", "southcentralus", "eastus", "east us"], lower(var.region))
    error_message = "Value must be \"Brazil South\" or \"South Central US\"."
  }
}

variable "private_cluster_enabled" {
  type    = bool
  default = true
}

variable "private_dns_zone_id" {
  type    = string
  default = null
}

variable "kubernetes_version" {
  type    = string
  default = "1.25.5"
}

variable "key_vault_id" {
  type = string
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

variable "node_pool_name" {
  type = string
}

variable "enable_auto_scaling" {
  type    = bool
  default = true
}

variable "min_count" {
  type    = number
  default = null
}

variable "max_count" {
  type    = number
  default = null
}

variable "node_count" {
  type    = number
  default = 1
}

variable "only_critical_addons_enabled" {
  type    = bool
  default = false
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "vm_size" {
  type = string
  default = "Standard_B2s"
}

variable "acr_id" {
  type = string
  default = null
}

variable "vnet_subnet_id_nodes" {
  type = string
}

variable "vnet_subnet_id_services" {
  type = list(any)
}

variable "max_pods" {
  type    = number
  default = 30
}

variable "os_disk_type" {
  type    = string
  default = "Managed"
}

variable "os_disk_size_gb" {
  type = number
  default = 128
}

variable "zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "nodepool_adv_config" {
  type    = any
  default = {}
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "load_balancer_sku" {
  type    = string
  default = "standard"
}

variable "network_plugin" {
  type    = string
  default = "azure"
}

variable "pod_cidr" {
  type    = string
  default = null
}

variable "service_cidr" {
  type    = string
  default = "10.254.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.254.0.10"
}

variable "network_policy" {
  type    = string
  default = "azure"
}

variable "outbound_type" {
  type    = string
  default = "loadBalancer"
}

variable "admin_group_object_ids" {
  type    = list(string)
}

variable "linux_username" {
  type      = string
  default   = "adminuser"
  sensitive = true
}

variable "key_data" {
  type      = string
  sensitive = true
}

variable "number" {
  type    = number
  default = 1
}

variable "environment" {
  type = string
  default = "dev"

}

variable "resource_lock" {
  type        = string
  default     = ""
  description = "Defines if the resource will receive lock or not."
  validation {
    condition     = contains(["cannotdelete", "read", ""], var.resource_lock)
    error_message = "Value must be \"cannotdelete\" or \"readonly\"."
  }
}

variable "ingress_chart_version" {
  type    = string
  default = "4.6.1"
}

variable "ingress_chart_replicaCount" {
  type    = number
  default = 2
}

variable "ingress_loadbalancer_ip" {
  type = string
}

variable "private_dns_rg" {
  type = string
}

# variable "logs" {
#   type = object({
#     storage_account_id = string
#     log_analytics_workspace_id = string
#   })
#   default = null
# }
