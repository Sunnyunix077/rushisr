terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.50.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}
