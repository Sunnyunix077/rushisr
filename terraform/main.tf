module "keypair" {
  source = "./modules/keypair"
 
  keypair_name = var.keypair_name
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

  instance_name = var.instance_name
  instance_flavor = var.instance_flavor
  instance_image = var.instance_image
  instance_network = var.instance_network
  keypair_name = module.keypair.keypair_name
  sg_id = module.sgcreate.sg_id
  float_ip  = module.floatipcreate.float_ip[0]
#  volume_id = module.volcreate.volume_id
 depends_on = [
    module.keypair,
    module.sgcreate,
    module.floatipcreate
  ]
}

# Attach the floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "my_instance_floating_ip" {
  floating_ip = module.floatipcreate.float_ip[0]
  instance_id = module.compute.instance_id[0]
}

# Attach the new volume to the instance
resource "openstack_compute_volume_attach_v2" "test-attach" {
  instance_id = module.compute.instance_id[0]
  volume_id   = module.volcreate.volume_id[0]
}

#resource "local_file" "ansible_inventory_file" {
#  content = <<EOF
#[servers]
#${join("\n", formatlist(module.floatipcreate.float_ip))}
#  EOF
#
#  filename = var.ansible_inventory_file_path
#}
# generate inventory file for Ansible
#resource "local_file" "hosts_cfg" {
#  content = templatefile("${path.module}/hosts.tpl",
#    {
#      servers = join("\n", module.floatipcreate.float_ip)
#    }
#  )
#  filename = var.ansible_inventory_file_path
#}
resource "local_file" "hosts_cfg" {
  content  = "[servers]\n${join("\n", module.floatipcreate.float_ip)}"
  filename = var.ansible_inventory_file_path
}
#data  "template_file" "hosts" {
#  template = "${file("./hosts.tpl")}"
#  vars = {
#    servers = join("\n",  module.floatipcreate.float_ip)
#  }
#}
#
#resource "local_file" "hosts_file" {
#  content  = data.template_file.hosts.rendered
#  filename = var.ansible_inventory_file_path
#}
