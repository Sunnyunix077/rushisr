terraform {
  required_version = "1.4.6"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
  }
}

locals {
  instance_prefixes = [
    "labdpl",
    "labcm",
    "labcr",
    "labst",
  ]
}
# Create a new instance
resource "openstack_compute_instance_v2" "test-instance" {

  count = var.instance_count
  name            = format(
    "%s%02d%s",
    local.instance_prefixes[count.index < 4 ? count.index : (count.index % 3) + 1],
    count.index < 4 ? 1 : floor((count.index - 4) / 3) + 2,
    var.instance_suffix != "" ? var.instance_suffix : ""
  )
  flavor_name     = var.instance_flavors[count.index]
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  network {
    name = var.instance_network
  }
  access_ip_v4 = var.float_ip
  instance_flavor = var.instance_flavor != "" ? var.instance_flavor : ""
}
