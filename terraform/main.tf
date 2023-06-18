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

#module "volcreate" {
#  source = "./modules/volcreate"
#  
#  volume_name = var.volume_name
#  volume_size = var.volume_size
#  volume_type = var.volume_type
#  volume_id = module.volcreate.volume_id
#}

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

#Working code as below :
#resource "local_file" "hosts_cfg" {
#  content  = "[servers]\n${join("\n", module.floatipcreate.float_ip)}"
#  filename = var.ansible_inventory_file_path
#}
locals {
  instances_with_floatip = {for i_instance_name, f_instance_name, floating_ip_value in ziplist(module.compute.instances_names,module.compute.instance_id,module.floating_ips.float_ip) : module.compute.instances_names_and_ids[f_instance_name] => floating_ip_value if can(regex(f_instance_name,i_instance_name))}
  instances_with_prefix = {for k in module.compute.instance_prefixes :
    k => [for key, value in local.instances_with_floatip: {name=key, access_ip_v4=value} if substr(key.name,0,length(k)) == k]
  }
}
resource "local_file" "ansible_inventory" {
  content = join("\n\n", [
    for prefix, instances in local.instances_with_prefix: format("%s-group\n%s", prefix,
      join("\n", [
        for instance in instances: instance.access_ip_v4
      ])
    )
  ])
filename = var.ansible_inventory_file_path
depends_on = [module.compute]
}
#resource "local_file" "hosts_cfg" {
#  content  = templatefile("${path.module}/ansible_inventory.tmpl", { servers = join("\n", module.floatipcreate.float_ip) })
#  filename = var.ansible_inventory_file_path
#}
