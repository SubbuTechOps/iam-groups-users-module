# variables.tf
variable "admin_users" {
  type        = list(string)
  description = "List of admin users to be created"
  default     = []
}

variable "developer_users" {
  type        = list(string)
  description = "List of developer users to be created"
  default     = []
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "use_existing_admin_group" {
  type        = bool
  default     = false
  description = "Use existing admin group instead of creating new one"
}

variable "use_existing_dev_group" {
  type        = bool
  default     = false
  description = "Use existing developer group instead of creating new one"
}

variable "admin_group_name" {
  type        = string
  default     = ""
  description = "Existing admin group name"
}

variable "developer_group_name" {
  type        = string
  default     = ""
  description = "Existing developer group name"
}
