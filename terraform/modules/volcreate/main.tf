terraform {
  required_version = "1.4.6"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
  }
}

# Create a new volume
resource "openstack_blockstorage_volume_v3" "test-volume" {
  name = var.volume_name
  size = var.volume_size
  volume_type = var.volume_type
  count = 1
}
