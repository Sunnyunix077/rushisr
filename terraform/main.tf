module "keypair" {
  source = "./modules/keypair"
 
  keypair_name = var.keypair_name
  public_key   = var.public_key
}

module "sgcreate" {
  source = "./modules/sgcreate"
  
  floating_ip_pool = var.floating_ip_pool
  security_group_name = var.security_group_name
  security_group_description = var.security_group_description
}

module "volcreate" {
  source = "./modules/volcreate"
  
  volume_name = var.volume_name
  volume_size = var.volume_size
  volume_type = var.volume_type
#  volume_id = module.volcreate.volume_id
}

module "floatipcreate" {
  source = "./modules/floatipcreate"
  
  floating_ip_pool = var.floating_ip_pool
}

module "compute" {
  source = "./modules/compute"
  instance_name = "lab"
  instance_prefix = "lab"
  instance_suffix = "cn"
  instance_count = 10
  instance_types    = concat(
    [for _ in range(var.instance_count) : "dpl"],
    [for i in range(1, 4) : format("cr%02d", i)],
    [for i in range(1, 4) : format("cm%02d", i)],
    [for i in range(1, 4) : format("st%02d", i)]
  )
  instance_image    = var.instance_image
  instance_network  = var.instance_network
  keypair_name      = module.keypair.keypair_name
  sg_id             = module.sgcreate.sg_id
  float_ip          = module.floatipcreate.float_ip[0]
  flavor_dpl_cm_st_ = "IaaS.Vcpu_2.ram_4.disk_40"
  flavor_cr_       = "IaaS.Vcpu_2.ram_14.disk_40"
#  volume_id = module.volcreate.volume_id
 depends_on = [
    module.keypair,
    module.sgcreate,
    module.floatipcreate
  ]
}

# Attach the floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "my_instance_floating_ip" {
  count       = length(module.compute.instance_id)
  floating_ip = element(module.floatipcreate.float_ip, count.index)
  instance_id = element(module.compute.instance_id, count.index)
}

# Attach the new volume to the instance
#resource "openstack_compute_volume_attach_v2" "test-attach" {
#  count     = length(module.compute.instance_id)
#  volume_id = element(module.volcreate.volume_id, count.index)
#  instance_id = element(module.compute.instance_id, count.index)
#}
locals {
  storage_instances = ["labst01cn", "labst02cn", "labst03cn"]
}

resource "openstack_compute_volume_attach_v2" "volume_attach" {
  count = length(local.storage_instances)
  instance_id = module.compute.instances_info[local.storage_instances[count.index]]
  volume_id = module.volcreate.volume_id[count.index]
  device = "/dev/vdb"
}



#Working code as below :
#resource "local_file" "hosts_cfg" {
#  content  = "[servers]\n${join("\n", module.floatipcreate.float_ip)}"
#  filename = var.ansible_inventory_file_path
#}
#locals {
#  instances_with_floatip = {for idx, instance_id in module.compute.instance_id : module.compute.instances_names[idx] => module.floatipcreate.float_ip[idx]}
#  instances_with_prefix = {for k in module.compute.instance_prefixes :
#    k => [for key, value in local.instances_with_floatip: {name=key, access_ip_v4=value} if substr(key,0,length(k)) == k]
#  }
#}
#resource "local_file" "ansible_inventory" {
#  content = join("\n\n", [
#    for prefix, instances in local.instances_with_prefix: format("[%s]\n%s", prefix,
#      join("\n", [
#        for instance in instances: instance.access_ip_v4
#      ])
#    )
#  ])
#filename = var.ansible_inventory_file_path
#depends_on = [module.compute]
#}

locals {
  instances_with_floatip = {for idx, instance_id in module.compute.instance_id : module.compute.instances_names[idx] => module.floatipcreate.float_ip[idx]}
  instances_with_prefix = {for k in module.compute.instance_prefixes :
    k => [for key, value in local.instances_with_floatip: {name=key, access_ip_v4=value} if substr(key, 0, length(k)) == k]
  }
}
resource "local_file" "ansible_inventory" {
  content = join("\n\n", [
    for prefix, instances in local.instances_with_prefix: format("[%s]\n%s", prefix,
      join("\n", [
        for instance in instances: format("%s ansible_user=ubuntu ansible_ssh_private_key_file=\"{{ lookup('env', 'HOME') }}/.ssh/id_rsa\"", instance.access_ip_v4)
      ])
    )
  ])
  filename = var.ansible_inventory_file_path
  depends_on = [module.compute]
}
data "template_file" "hosts" {
  template = "${file("${path.module}/hosts.tpl")}"
  vars = {
    hostnames    = data.openstack_compute_instance_v2.test-instance.name
    floating_ips = data.openstack_networking_floatingip_v2.my_floating_ip_address
  }
}

resource "local_file" "hosts" {
  content  = data.template_file.hosts.rendered
  filename = "/etc/hosts"
}

#resource "local_file" "hosts_cfg" {
#  content  = templatefile("${path.module}/ansible_inventory.tmpl", { servers = join("\n", module.floatipcreate.float_ip) })
#  filename = var.ansible_inventory_file_path
#}
