auth_url = "https://zephyr02cn.netcracker.com:5000"
username = "rude0423"
#project_name = "RUDE0423"
user_domain_name = "netcracker"
keypair_name = "test-keypair"
volume_name = "test-volume"
volume_size = "10"
volume_type = "ceph_rude0423"
security_group_name = "test-security-group"
security_group_description = "Test security group"
instance_name = "test-instance"
instance_flavor = "m1.small"
instance_image = "ubuntu-20.04-cloudimg-amd64"
instance_network = "inner-net_RUDE0423"
#instance_network_2 = "inner-net_RUDE0423"
floating_ip_pool = "ext-net"
private_key_path = "~/.ssh/id_rsa"
ansible_inventory_file_path = "../ansible/inventory/hosts"
instance_count = 10
