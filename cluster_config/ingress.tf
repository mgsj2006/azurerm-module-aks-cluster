variable "ingress_chart_version" {
  type = string
}

variable "ingress_chart_replicaCount" {
  type = number
}

variable "ingress_loadbalancer_ip" {
  type = string
}

variable "vnet_subnet_id_nodes" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

locals {
  ingress_config = var.private_cluster_enabled == true ? {
    "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal-subnet\"" = "${reverse(split("/", var.vnet_subnet_id_nodes))[0]}"
    "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-ipv4\"" = "${var.ingress_loadbalancer_ip}"
    "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal\"" = "true"
  } : { "controller.service.loadBalancerIP" = "${var.ingress_loadbalancer_ip}" }
  set_default = {
    "controller.replicaCount" = tostring(var.ingress_chart_replicaCount),
    "controller.metrics.enabled" = "true", #for prometheus ingress monitor
    "controller.metrics.serviceMonitor.enabled" = true #for prometheus ingress monitor
    "controller.podAnnotations.\"prometheus\\.io/scrape\"" = true, #for prometheus ingress monitor
    "controller.podAnnotations.\"prometheus\\.io/port\"" = 10254, #for prometheus ingress monitor
    "controller.metrics.serviceMonitor.additionalLabels.release" = "monitor" #for prometheus ingress monitor
    #"controller.service.externalTrafficPolicy" = "Local",
    "controller.nodeSelector\\.beta\\.kubernetes\\.io/os" = "linux",
    "defaultBackend.nodeSelector\\.beta\\.kubernetes\\.io/os" = "linux",
    "defaultBackend.image.digest" = "",
    "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path\"" = "/healthz",
    #"controller.admissionWebhooks.enabled" = true,
    "controller.admissionWebhooks.patch.image.digest"= "",
    "controller.image.digest"= "",
    "controller.admissionWebhooks.patch.nodeSelectorenabled\\.beta\\.kubernetes\\.io/os" = "linux",
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [ kubernetes_storage_class_v1.prmdisk-zrs ]

  create_duration = "30s"
}

resource "helm_release" "ingress_nginx" {
  depends_on = [ time_sleep.wait_30_seconds ]
  name = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_chart_version
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
  

  dynamic "set" {
    for_each = local.set_default
    content {
      name = set.key
      value = set.value
    }
  }
  dynamic "set" {
    for_each = local.ingress_config
    content {
      name = set.key
      value = set.value
    }
  }
  # dynamic "set" {
  #   for_each = {
  #     "controller.resources.limits.cpu" = "100m"
  #     "controller.resources.limits.memory" = "90Mi"
  #     "controller.resources.request.cpu" = "100m"
  #     "controller.resources.request.memory" = "90Mi"
  #   }
  #   content {
  #     name = set.key
  #     value = set.value
  #   }
  # }
}
