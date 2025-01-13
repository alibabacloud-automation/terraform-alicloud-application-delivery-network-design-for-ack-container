provider "alicloud" {
  region = "cn-hangzhou"
}

module "complete" {
  source = "../.."

  vpc_cidr_block = var.vpc_cidr_block

  availability_zone    = var.availability_zone
  node_vswitch_cidrs   = var.node_vswitch_cidrs
  terway_vswitch_cidrs = var.terway_vswitch_cidrs

  cluster_config = var.cluster_config

  node_pool_config = var.node_pool_config

  alb_load_balancer_config = var.alb_load_balancer_config
}
