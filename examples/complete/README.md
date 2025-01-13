
# Complete

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_load_balancer_config"></a> [alb\_load\_balancer\_config](#input\_alb\_load\_balancer\_config) | The parameters used to create alb load balancer. | <pre>object({<br>    address_type           = optional(string, "Internet")<br>    address_allocated_mode = optional(string, null)<br>    pay_type               = optional(string, "PayAsYouGo")<br>    load_balancer_edition  = optional(string, "Basic")<br>  })</pre> | <pre>{<br>  "address_allocated_mode": "Fixed",<br>  "load_balancer_edition": "Basic"<br>}</pre> | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zones of vswitches. | `list(string)` | <pre>[<br>  "cn-hangzhou-i",<br>  "cn-hangzhou-j",<br>  "cn-hangzhou-k"<br>]</pre> | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | The parameters used to create managed kubernetes cluster. | <pre>object({<br>    name                         = optional(string, null)<br>    cluster_spec                 = optional(string, null)<br>    ack_version                  = optional(string, null)<br>    new_nat_gateway              = optional(bool, true)<br>    service_cidr                 = optional(string, null)<br>    pod_cidr                     = optional(string, null)<br>    slb_internet_enabled         = optional(bool, true)<br>    enable_rrsa                  = optional(bool, true)<br>    control_plane_log_components = optional(list(string), null)<br>  })</pre> | <pre>{<br>  "ack_version": "1.31.1-aliyun.1",<br>  "cluster_spec": "ack.pro.small",<br>  "control_plane_log_components": [<br>    "apiserver",<br>    "kcm",<br>    "scheduler",<br>    "ccm"<br>  ],<br>  "service_cidr": "10.11.0.0/16"<br>}</pre> | no |
| <a name="input_node_pool_config"></a> [node\_pool\_config](#input\_node\_pool\_config) | The parameters used to create node pool. | <pre>object({<br>    node_pool_name        = optional(string, "default-nodepool")<br>    instance_types        = list(string)<br>    instance_charge_type  = optional(string, "PostPaid")<br>    runtime_name          = optional(string, null)<br>    runtime_version       = optional(string, null)<br>    desired_size          = optional(number, null)<br>    password              = optional(string, null)<br>    install_cloud_monitor = optional(bool, true)<br>    system_disk_category  = optional(string, "cloud_efficiency")<br>    system_disk_size      = optional(number, 100)<br>    image_type            = optional(string, "AliyunLinux3")<br>    data_disks = optional(list(object({<br>      category = optional(string, "cloud_essd")<br>      size     = optional(number, 120)<br>    })), [])<br>  })</pre> | <pre>{<br>  "data_disks": [<br>    {<br>      "category": "cloud_essd",<br>      "size": 120<br>    }<br>  ],<br>  "desired_size": 2,<br>  "instance_types": [<br>    "ecs.g6.2xlarge",<br>    "ecs.g6.xlarge"<br>  ],<br>  "runtime_name": "containerd",<br>  "runtime_version": "1.6.20"<br>}</pre> | no |
| <a name="input_node_vswitch_cidrs"></a> [node\_vswitch\_cidrs](#input\_node\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches. | `list(string)` | <pre>[<br>  "172.16.0.0/23",<br>  "172.16.2.0/23",<br>  "172.16.4.0/23"<br>]</pre> | no |
| <a name="input_terway_vswitch_cidrs"></a> [terway\_vswitch\_cidrs](#input\_terway\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches. | `list(string)` | <pre>[<br>  "172.17.0.0/20",<br>  "172.18.0.0/20",<br>  "172.19.0.0/20"<br>]</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The cidr block of the VPC. | `string` | `"172.16.0.0/12"` | no |

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