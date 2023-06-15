terraform {
  required_version = "1.4.6"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
  }
}

# Create a new instance
resource "openstack_compute_instance_v2" "test-instance" {

  count           = var.instance_count
  name            = element(local.instance_names, count.index)
  flavor_name     = var.instance_flavor
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  network {
    name = var.instance_network
  }
  access_ip_v4 = var.float_ip
}
  locals {
  dpl_instance_names = [for i in range(1, var.instance_count + 1) : format("labdpl%02dcn", i)]
  cr_instance_names  = flatten([for i in range(1, 4) : [format("labcr%02dcn", i)]])
  cm_instance_names  = flatten([for i in range(1, 4) : [format("labcm%02dcn", i)]])
  st_instance_names  = flatten([for i in range(1, 4) : [format("labst%02dcn", i)]])

  instance_names = flatten([
    local.dpl_instance_names,
    local.cr_instance_names,
    local.cm_instance_names,
    local.st_instance_names
  ])
}

locals {
  instance_names = slice(local.instance_names, 0, var.instance_count)
}
