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
  name            = format(
    "%s%s%02d",
    local.instance_prefix[count.index % length(local.instance_prefix)],
    var.instance_suffix != "" ? var.instance_suffix : "",
    ((count.index / length(local.instance_prefix)) % 3) + 1
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

locals {
  instance_prefix = [
    "labdpl",
    "labcr",
    "labcr",
    "labcr",
    "labcm",
    "labcm",
    "labcm",
    "labst",
    "labst",
    "labst",
  ]
}