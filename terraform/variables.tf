variable "auth_url" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}
variable "user_domain_name" {
  type = string
}

variable "keypair_name" {
  type = string
}

variable "volume_name" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "security_group_name" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "instance_name" {
  type = string
}

#variable "instance_flavor" {
#  type = string
#}

variable "instance_image" {
  type = string
}

variable "instance_network" {
  type = string
}

#variable "instance_network_2" {
#  type = string
#}

variable "volume_type" {
  type = string
}

variable "floating_ip_pool" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "ansible_inventory_file_path" {
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}
variable "hostnames" {
  type    = list(string)
  default = [
    "labst02cn",
    "labcm01cn",
    "labst01cn",
    "labdpl03cn",
    "labdpl02cn",
    "labdpl01cn",
    "labcr03cn",
    "labcr02cn",
    "labcr01cn",
    "labcm02cn"
  ]
}