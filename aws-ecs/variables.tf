variable "app_port" {
  default = 80
}

variable "cluster_name" {
  type = string
}

variable "task_definition_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "service_name" {
  type = string
}

variable "task_desired_count" {
  default = 2
}

variable "elb_name" {
  type = string
}

variable "elb_target_group_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "task_security_group_name" {
  type = string
}

variable "elb_security_group_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  default = "192.170.0.0/16"
  type = string
}

variable "azs" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "public_subnets_cidrs" {
  type = list(string)
  default = ["192.170.0.0/24", "192.170.1.0/24", "192.170.2.0/24"]
}

variable "ecs_tasks_execution_role" {
  type = string
}