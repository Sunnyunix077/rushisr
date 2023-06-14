output "ansible_inventory" {
  value = {
    servers = module.floatipcreate.float_ip
  }
}
