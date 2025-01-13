# VPC
variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "The cidr block of the VPC."
  type        = string
  default     = null
}

# VSwitch
variable "availability_zone" {
  description = "The availability zones of vswitches."
  type        = list(string)
  default     = []
}

variable "node_vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches."
  type        = list(string)
  default     = []
}

variable "terway_vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches."
  type        = list(string)
  default     = []
}

# ACK
variable "cluster_config" {
  description = "The parameters used to create managed kubernetes cluster."
  type = object({
    name                         = optional(string, null)
    cluster_spec                 = optional(string, null)
    ack_version                  = optional(string, null)
    new_nat_gateway              = optional(bool, true)
    service_cidr                 = optional(string, null)
    pod_cidr                     = optional(string, null)
    slb_internet_enabled         = optional(bool, true)
    enable_rrsa                  = optional(bool, true)
    control_plane_log_components = optional(list(string), null)
  })
  default = {}
}

variable "cluster_addons" {
  description = "The addons to be installed in the cluster."
  type = list(object({
    name   = string
    config = string
  }))
  default = [
    {
      "name"   = "terway-eniip",
      "config" = "",
    },
    {
      "name"   = "logtail-ds",
      "config" = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      "name"   = "arms-prometheus",
      "config" = "",
    },
    {
      "name"   = "ack-node-problem-detector",
      "config" = "{\"sls_project_name\":\"\"}",
    },
    {
      "name"   = "csi-plugin",
      "config" = "",
    },
    {
      "name"   = "csi-provisioner",
      "config" = "",
    },
    {
      "name"   = "alb-ingress-controller",
      "config" = "{\"IngressSlbNetworkType\":\"internet\"}"
    }
  ]
}

variable "node_pool_config" {
  description = "The parameters used to create node pool."
  type = object({
    node_pool_name        = optional(string, "default-nodepool")
    instance_types        = list(string)
    instance_charge_type  = optional(string, "PostPaid")
    runtime_name          = optional(string, null)
    runtime_version       = optional(string, null)
    desired_size          = optional(number, null)
    password              = optional(string, null)
    install_cloud_monitor = optional(bool, true)
    system_disk_category  = optional(string, "cloud_efficiency")
    system_disk_size      = optional(number, 100)
    image_type            = optional(string, "AliyunLinux3")
    data_disks = optional(list(object({
      category = optional(string, "cloud_essd")
      size     = optional(number, 120)
    })), [])
  })
  default = {
    instance_types = []
  }

}

variable "alb_load_balancer_config" {
  description = "The parameters used to create alb load balancer."
  type = object({
    address_type           = optional(string, "Internet")
    address_allocated_mode = optional(string, null)
    pay_type               = optional(string, "PayAsYouGo")
    load_balancer_edition  = optional(string, "Basic")
  })
  default = {}

}
