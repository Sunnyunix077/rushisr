variable "instance_name" {
  type = string
}

variable "instance_flavor" {
  type = string
}

variable "instance_image" {
  type = string
}

variable "instance_network" {
  type = string
}

variable "keypair_name" {
  type = string
}

variable "sg_id" {
  type = string
}

#variable "volume_id" {
#  type = string
#}

variable "float_ip" {
  type = string
}

variable "instance_prefix" {
  description = "Prefix for the instance hostname"
  type        = string
}

variable "instance_suffix" {
  description = "Suffix for the instance hostname"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "instance_types" {
  description = "List of instance types"
  type        = list(string)
}

variable "flavor_dpl_cm_st_" {
   description = "Flavor used for dpl, cm and st instances"
   type = string
   default = ""
}

variable "flavour_cr_" {
   description = "Flavour used for cr instances"
   type = string
   default = ""
}