#output "instance_ip" {
#  value = module.compute.instance_ip
#}
output "ansible_inventory" {
  value = {
    servers = module.floatipcreate.float_ip
  }
}
