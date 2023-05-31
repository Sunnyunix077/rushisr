terraform {
  required_version = "1.4.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
  }
}

# Create a new volume
resource "openstack_blockstorage_volume_v3" "test-volume" {
  name = var.volume_name
  size = var.volume_size # GB
  volume_type = var.volume_type
  count = 1
}
