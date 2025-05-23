Terraform module to provide a network ingress design guide for Kubernetes (k8s) clusters for Alibaba Cloud

terraform-alicloud-application-delivery-network-design-for-ack-container
======================================

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-application-delivery-network-design-for-ack-container/blob/main/README-CN.md)

This module aims to provide a network ingress design guide for Kubernetes (k8s) clusters, focusing on the design strategies of the two core components, Service and Ingress, to improve the efficiency, security, stability, and performance of service access. It recommends using the fully managed ALB Ingress as the unified entry point for the cluster. Compared to the traditional Nginx Ingress, ALB Ingress requires no additional maintenance, automatically monitors changes in Ingress resources within Kubernetes, and intelligently distributes traffic based on predefined rules. Furthermore, ALB Ingress offers robust elasticity and scaling capabilities, dynamically adjusting resource allocation according to traffic fluctuations to ensure stable operation even under high concurrency or traffic surges. This design not only simplifies operations but also significantly enhances the reliability and flexibility of the cluster.

Architecture Diagram:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-application-delivery-network-design-for-ack-container/main/scripts/diagram.png)


## Usage

```hcl
provider "alicloud" {
  region = "cn-hangzhou"
}

module "complete" {
  source = "alibabacloud-automation/application-delivery-network-design-for-ack-container/alicloud"

  vpc_cidr_block = "172.16.0.0/12"

  availability_zone    = ["cn-hangzhou-i", "cn-hangzhou-j", "cn-hangzhou-k"]
  node_vswitch_cidrs   = ["172.16.0.0/23", "172.16.2.0/23", "172.16.4.0/23"]
  terway_vswitch_cidrs = ["172.17.0.0/20", "172.18.0.0/20", "172.19.0.0/20"]

  cluster_config = {
    cluster_spec                 = "ack.pro.small"
    ack_version                  = "1.31.1-aliyun.1"
    service_cidr                 = "10.11.0.0/16"
    control_plane_log_components = ["apiserver", "kcm", "scheduler", "ccm"]
  }

  node_pool_config = {
    runtime_name    = "containerd"
    runtime_version = "1.6.20"
    instance_types  = ["ecs.g6.2xlarge", "ecs.g6.xlarge"]
    desired_size    = 2
    data_disks = [{
      category = "cloud_essd"
      size     = 120
    }]
  }

  alb_load_balancer_config = {
    load_balancer_edition  = "Basic"
    address_allocated_mode = "Fixed"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-application-delivery-network-design-for-ack-container/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_alb_load_balancer.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/alb_load_balancer) | resource |
| [alicloud_cs_kubernetes_node_pool.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cs_kubernetes_node_pool) | resource |
| [alicloud_cs_managed_kubernetes.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cs_managed_kubernetes) | resource |
| [alicloud_vpc.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.terway_vswitches](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.vswitches](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_load_balancer_config"></a> [alb\_load\_balancer\_config](#input\_alb\_load\_balancer\_config) | The parameters used to create alb load balancer. | <pre>object({<br>    address_type           = optional(string, "Internet")<br>    address_allocated_mode = optional(string, null)<br>    pay_type               = optional(string, "PayAsYouGo")<br>    load_balancer_edition  = optional(string, "Basic")<br>  })</pre> | `{}` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zones of vswitches. | `list(string)` | `[]` | no |
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | The addons to be installed in the cluster. | <pre>list(object({<br>    name   = string<br>    config = string<br>  }))</pre> | <pre>[<br>  {<br>    "config": "",<br>    "name": "terway-eniip"<br>  },<br>  {<br>    "config": "{\"IngressDashboardEnabled\":\"true\"}",<br>    "name": "logtail-ds"<br>  },<br>  {<br>    "config": "",<br>    "name": "arms-prometheus"<br>  },<br>  {<br>    "config": "{\"sls_project_name\":\"\"}",<br>    "name": "ack-node-problem-detector"<br>  },<br>  {<br>    "config": "",<br>    "name": "csi-plugin"<br>  },<br>  {<br>    "config": "",<br>    "name": "csi-provisioner"<br>  },<br>  {<br>    "config": "{\"IngressSlbNetworkType\":\"internet\"}",<br>    "name": "alb-ingress-controller"<br>  }<br>]</pre> | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | The parameters used to create managed kubernetes cluster. | <pre>object({<br>    name                         = optional(string, null)<br>    cluster_spec                 = optional(string, null)<br>    ack_version                  = optional(string, null)<br>    new_nat_gateway              = optional(bool, true)<br>    service_cidr                 = optional(string, null)<br>    pod_cidr                     = optional(string, null)<br>    slb_internet_enabled         = optional(bool, true)<br>    enable_rrsa                  = optional(bool, true)<br>    control_plane_log_components = optional(list(string), null)<br>  })</pre> | `{}` | no |
| <a name="input_node_pool_config"></a> [node\_pool\_config](#input\_node\_pool\_config) | The parameters used to create node pool. | <pre>object({<br>    node_pool_name        = optional(string, "default-nodepool")<br>    instance_types        = list(string)<br>    instance_charge_type  = optional(string, "PostPaid")<br>    runtime_name          = optional(string, null)<br>    runtime_version       = optional(string, null)<br>    desired_size          = optional(number, null)<br>    password              = optional(string, null)<br>    install_cloud_monitor = optional(bool, true)<br>    system_disk_category  = optional(string, "cloud_efficiency")<br>    system_disk_size      = optional(number, 100)<br>    image_type            = optional(string, "AliyunLinux3")<br>    data_disks = optional(list(object({<br>      category = optional(string, "cloud_essd")<br>      size     = optional(number, 120)<br>    })), [])<br>  })</pre> | <pre>{<br>  "instance_types": []<br>}</pre> | no |
| <a name="input_node_vswitch_cidrs"></a> [node\_vswitch\_cidrs](#input\_node\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches. | `list(string)` | `[]` | no |
| <a name="input_terway_vswitch_cidrs"></a> [terway\_vswitch\_cidrs](#input\_terway\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches. | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The cidr block of the VPC. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_load_balancer_id"></a> [alb\_load\_balancer\_id](#output\_alb\_load\_balancer\_id) | The id of alb load balancer. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The id of managed kubernetes cluster. |
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | The id of node pool. |
| <a name="output_terway_vswitch_id"></a> [terway\_vswitch\_id](#output\_terway\_vswitch\_id) | The ID of the terway VSwitches |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitches |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
