output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.complete.vpc_id
}

output "vswitch_id" {
  description = "The ID of the VSwitches"
  value       = module.complete.vswitch_id
}

output "terway_vswitch_id" {
  description = "The ID of the terway VSwitches"
  value       = module.complete.terway_vswitch_id
}

output "cluster_id" {
  description = "The id of managed kubernetes cluster."
  value       = module.complete.cluster_id
}

output "node_pool_id" {
  description = "The id of node pool."
  value       = module.complete.node_pool_id
}

output "alb_load_balancer_id" {
  description = "The id of alb load balancer."
  value       = module.complete.alb_load_balancer_id
}
