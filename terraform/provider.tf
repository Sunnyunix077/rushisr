provider "openstack" {
  auth_url          = var.auth_url
  user_name         = var.username
  password          = var.password
  user_domain_name  = var.user_domain_name
}
provider "local" {}
provider "random" {}
