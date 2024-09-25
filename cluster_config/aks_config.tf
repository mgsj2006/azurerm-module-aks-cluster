provider "kubernetes" {
  host = var.host

  username               = var.username
  password               = var.password
  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host = var.host

    username               = var.username
    password               = var.password
    client_certificate     = var.client_certificate
    client_key             = var.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

variable "host" {
  type      = string
  sensitive = true
}
variable "client_certificate" {
  type      = string
  sensitive = true
}
variable "client_key" {
  type      = string
  sensitive = true
}
variable "cluster_ca_certificate" {
  type      = string
  sensitive = true
}
variable "username" {
  type      = string
  sensitive = true
}
variable "password" {
  type      = string
  sensitive = true
}
variable "stg_id" {
  type = string
}

resource "kubernetes_annotations" "default" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = true

  metadata {
    name = "default"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "true"
  }
}

resource "kubernetes_storage_class_v1" "azurefile-zrs" {
  depends_on = [
    kubernetes_annotations.default
  ]
  metadata {
    name = "azurefile-zrs"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  storage_provisioner = "file.csi.azure.com"
  reclaim_policy      = "Delete"
  parameters = {
    resourceGroup: split("/", var.stg_id)[4]
    storageAccount: reverse(split("/", var.stg_id))[0]
    server: "${reverse(split("/", var.stg_id))[0]}.privatelink.file.core.windows.net"
    skuName = "Premium_ZRS"
  }
  mount_options = [ 
    "dir_mode=0777",
    "file_mode=0777",
    "uid=0",
    "gid=0",
    "mfsymlinks",
    "nosharesock",
    "cache=strict",
    "actimeo=30"
  ]
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true
}

resource "kubernetes_storage_class_v1" "stddisk-zrs" {
  depends_on = [ kubernetes_storage_class_v1.azurefile-zrs ]
  metadata {
    name = "stddisk-zrs"
  }
  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"
  parameters = {
    skuName = "StandardSSD_ZRS"
  }
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
}

resource "kubernetes_storage_class_v1" "prmdisk-zrs" {
  depends_on = [ kubernetes_storage_class_v1.azurefile-zrs ]
  metadata {
    name = "prmdisk-zrs"
  }
  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"
  parameters = {
    skuName = "Premium_ZRS"
  }
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
}