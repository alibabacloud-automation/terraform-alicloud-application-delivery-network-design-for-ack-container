
variable "vpc_cidr_block" {
  description = "The cidr block of the VPC."
  type        = string
  default     = "172.16.0.0/12"
}

# VSwitch
variable "availability_zone" {
  description = "The availability zones of vswitches."
  type        = list(string)
  default     = ["cn-hangzhou-i", "cn-hangzhou-j", "cn-hangzhou-k"]
}

variable "node_vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches."
  type        = list(string)
  default     = ["172.16.0.0/23", "172.16.2.0/23", "172.16.4.0/23"]
}

variable "terway_vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches."
  type        = list(string)
  default     = ["172.17.0.0/20", "172.18.0.0/20", "172.19.0.0/20"]
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
  default = {
    cluster_spec                 = "ack.pro.small"
    ack_version                  = "1.34.1-aliyun.1"
    service_cidr                 = "10.11.0.0/16"
    control_plane_log_components = ["apiserver", "kcm", "scheduler", "ccm"]
  }
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
    runtime_name    = "containerd"
    runtime_version = "1.6.20"
    instance_types  = ["ecs.g6.2xlarge", "ecs.g6.xlarge"]
    desired_size    = 2
    data_disks = [{
      category = "cloud_essd"
      size     = 120
    }]
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
  default = {
    load_balancer_edition  = "Basic"
    address_allocated_mode = "Fixed"
  }

}
