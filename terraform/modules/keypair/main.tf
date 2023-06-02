terraform {
  required_version = "1.4.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
  }
}
# Create a new keypair
resource "openstack_compute_keypair_v2" "test-keypair" {
  name      = var.keypair_name
  public_key = var.public_key
}
