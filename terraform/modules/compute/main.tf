terraform {
  required_version = "=1.4.6"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.51.1"
    }
  }
}

# Create a new instance
resource "openstack_compute_instance_v2" "test-instance" {
  name            = var.instance_name
  flavor_name     = var.instance_flavor
  key_pair        = var.keypair_name
  security_groups = [var.sg_id]
  image_name      = var.instance_image
  count		  = 1
  network {
    name = var.instance_network
  }
  access_ip_v4 = var.float_ip
}
