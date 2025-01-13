output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.default.id
}

output "vswitch_id" {
  description = "The ID of the VSwitches"
  value       = alicloud_vswitch.vswitches[*].id
}

output "terway_vswitch_id" {
  description = "The ID of the terway VSwitches"
  value       = alicloud_vswitch.terway_vswitches[*].id
}

output "cluster_id" {
  description = "The id of managed kubernetes cluster."
  value       = alicloud_cs_managed_kubernetes.default.id
}

output "node_pool_id" {
  description = "The id of node pool."
  value       = alicloud_cs_kubernetes_node_pool.default.node_pool_id
}

output "alb_load_balancer_id" {
  description = "The id of alb load balancer."
  value       = alicloud_alb_load_balancer.default.id
}
