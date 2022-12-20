#
# Variables Configuration
#

variable "cluster_name" {
  default = "magramseva-uat"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "network_availability_zones" {
  default = ["ap-south-1b", "ap-south-1a"]
}

variable "availability_zones" {
  default = ["ap-south-1b"]
}

variable "kubernetes_version" {
  default = "1.20"
}

variable "instance_type" {
  default = "m4.xlarge"
}

variable "override_instance_types" {
  default = ["r5a.large", "r5ad.large", "r5d.large", "m4.xlarge"]
  
}

variable "number_of_worker_nodes" {
  default = "1"
}

variable "ssh_key_name" {
  default = "magramseva-uat"
}

variable "db_name" {
  description = "RDS DB name. Make sure there are no hyphens or other special characters in the DB name. Else, DB creation will fail"
  default = "mgramseva_uat"
}

variable "db_password" {}

