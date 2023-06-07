output "float_ip" {
  value = tolist(openstack_networking_floatingip_v2.my_floating_ip.*.address)
}
