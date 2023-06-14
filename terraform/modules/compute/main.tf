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

  count        = length(var.instance_types) * var.instance_count
  name = substr("${var.instance_name}${join("", flatten([for i in var.instance_types : [for j in range(1, var.instance_count + 1) : format("%s%02d%s", i, j, var.instance_suffix)]]))}", 0, 64)
  flavor_name     = var.instance_flavor
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  network {
    name = var.instance_network
  }
  access_ip_v4 = var.float_ip
}
