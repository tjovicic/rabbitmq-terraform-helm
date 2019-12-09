variable "project_name" {
  default = "sandbox"
}

variable "region" {
  default = "us-east1"
}

variable "cluster" {
  default = "rabbitmq-cluster"
}

variable "cluster_node_pool" {
  default = "rabbitmq-cluster-node-pool"  
}

variable "cluster_version_prefix" {
  default = "1.12"
}

variable "cluster_initial_node_count" {
  default = 1
}

variable "network" {
  default = "default"
}

variable "node_pool_min_node_count" {
  default = 1
}

variable "node_pool_max_node_count" {
  default = 6
}

variable "node_disk_size_gb" {
  default = 100
}

variable "node_disk_type" {
  default = "pd-standard"
}

variable "node_machine_type" {
  default = "n1-standard-1"
}

variable "node_image_type" {
  default = "COS"
}
