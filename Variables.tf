variable "pat" {
  type = string
  description = "API token"
}


variable "instance_name" {
  type = string
  description = "Instance name"
}

variable "instance_region" {
  type = string
  description = "Region to deploy the instance"
}
variable "pvt_key" {
  type = string
  description = "Path to the private key"
}

variable "scripts_path" {
  type = string
}

variable "do_token" {
  type = string
}

variable "subdomain_name" {
  type = string
  description = "Sub-domain name to map to the infisical server ip"
}

variable "project_name" {
  type = string
  description = "Project id to deploy the resources into"
}         

variable "image" {
  type = string
  description = "Droplet OS image name"
}

variable "instance_size" {
  type = string
  description = "Server instance type"
}