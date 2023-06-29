output "instance_ip" {
  value = openstack_compute_instance_v2.test-instance.*.access_ip_v4
}
output "instance_id" {
  value = openstack_compute_instance_v2.test-instance.*.id
}

output "instance_flavors" {
  description = "Flavors of the created instances"
  value       = openstack_compute_instance_v2.test-instance[*].flavor_name
}

output "instance_prefixes" {
  value = local.instance_prefixes
}
output "instances" {
  value = openstack_compute_instance_v2.test-instance
}
output "instances_names" {
  value = openstack_compute_instance_v2.test-instance.*.name
}
output "instances_info" {
  value = {for i in openstack_compute_instance_v2.instance : i.name => i.id}
}
