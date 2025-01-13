resource "alicloud_vpc" "default" {
  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr_block
}

resource "alicloud_vswitch" "vswitches" {
  count      = length(var.node_vswitch_cidrs)
  vpc_id     = alicloud_vpc.default.id
  cidr_block = element(var.node_vswitch_cidrs, count.index)
  zone_id    = element(var.availability_zone, count.index)
}

resource "alicloud_vswitch" "terway_vswitches" {
  count      = length(var.terway_vswitch_cidrs)
  vpc_id     = alicloud_vpc.default.id
  cidr_block = element(var.terway_vswitch_cidrs, count.index)
  zone_id    = element(var.availability_zone, count.index)
}


resource "alicloud_cs_managed_kubernetes" "default" {
  name                         = var.cluster_config.name
  cluster_spec                 = var.cluster_config.cluster_spec
  version                      = var.cluster_config.ack_version
  worker_vswitch_ids           = alicloud_vswitch.vswitches[*].id
  pod_vswitch_ids              = alicloud_vswitch.terway_vswitches[*].id
  new_nat_gateway              = var.cluster_config.new_nat_gateway
  service_cidr                 = var.cluster_config.service_cidr
  pod_cidr                     = var.cluster_config.pod_cidr
  slb_internet_enabled         = var.cluster_config.slb_internet_enabled
  enable_rrsa                  = var.cluster_config.enable_rrsa
  control_plane_log_components = var.cluster_config.control_plane_log_components

  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
}


resource "alicloud_cs_kubernetes_node_pool" "default" {
  cluster_id            = alicloud_cs_managed_kubernetes.default.id
  vswitch_ids           = alicloud_vswitch.vswitches[*].id
  node_pool_name        = var.node_pool_config.node_pool_name
  instance_types        = var.node_pool_config.instance_types
  instance_charge_type  = var.node_pool_config.instance_charge_type
  runtime_name          = var.node_pool_config.runtime_name
  runtime_version       = var.node_pool_config.runtime_version
  desired_size          = var.node_pool_config.desired_size
  password              = var.node_pool_config.password
  install_cloud_monitor = var.node_pool_config.install_cloud_monitor
  system_disk_category  = var.node_pool_config.system_disk_category
  system_disk_size      = var.node_pool_config.system_disk_size
  image_type            = var.node_pool_config.image_type

  dynamic "data_disks" {
    for_each = var.node_pool_config.data_disks
    content {
      category = data_disks.value.category
      size     = data_disks.value.size
    }
  }
}


resource "alicloud_alb_load_balancer" "default" {
  vpc_id                 = alicloud_vpc.default.id
  address_type           = var.alb_load_balancer_config.address_type
  address_allocated_mode = var.alb_load_balancer_config.address_allocated_mode
  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.terway_vswitches
    content {
      vswitch_id = zone_mappings.value.id
      zone_id    = zone_mappings.value.zone_id
    }
  }
  load_balancer_billing_config {
    pay_type = var.alb_load_balancer_config.pay_type
  }
  load_balancer_edition = var.alb_load_balancer_config.load_balancer_edition
}

