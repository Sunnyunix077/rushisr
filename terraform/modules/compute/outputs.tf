output "instance_ip" {
  value = openstack_compute_instance_v2.test-instance.*.access_ip_v4
}
output "instance_id" {
  value = openstack_compute_instance_v2.test-instance.*.id
}

output "instance_flavors" {
  description = "Flavors of the created instances"
  value       = module.compute.openstack_compute_instance_v2[*].flavor_name
}

