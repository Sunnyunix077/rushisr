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

  count = length(local.instance_prefixes) > 1 ? var.instance_count : 1
  name            = format(
    "%s%02d%s",
    local.instance_prefixes[count.index % length(local.instance_prefixes)],
    floor((count.index / length(local.instance_prefixes)) % 3) + 1,
    var.instance_suffix != "" ? var.instance_suffix : ""
  )
  flavor_name     = var.instance_flavor
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  network {
    name = var.instance_network
  }
  access_ip_v4 = var.float_ip
}
