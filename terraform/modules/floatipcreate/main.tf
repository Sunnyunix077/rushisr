terraform {
  required_version = "1.4.6"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
  }
}


resource "openstack_networking_floatingip_v2" "my_floating_ip" {
  pool = var.floating_ip_pool
  count = 1
}
