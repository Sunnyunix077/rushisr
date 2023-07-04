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
  instance_flavors = [
    var.flavor_dpl_cm_st_,
    var.flavor_dpl_cm_st_,
    var.flavor_cr_,
    var.flavor_dpl_cm_st_
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
  flavor_name     = local.instance_flavors[count.index < 4 ? count.index : (count.index %3) +1]
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  network {
    name = var.instance_network
    port = openstack_networking_port_v2.test-port[count.index].id
  }
  access_ip_v4 = var.float_ip
}
resource "openstack_networking_port_v2" "test-port" {
  count = var.instance_count

  name       = format("port-%s-%02d", var.instance_network, count.index + 1)
  network_id = openstack_networking_network_v2.test-network.id
  fixed_ip   = var.assign_ip_to_second_interface ? null : []
  # Add any additional configuration for the port, if required
}
resource "openstack_networking_network_v2" "test-network" {
  name = var.instance_network
}