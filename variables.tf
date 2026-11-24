variable "project_name" {
  description = "Prefix used for Docker resources created by this lab."
  type        = string
  default     = "sdi4213-week12"
}

variable "web_port" {
  description = "Host port for the Week 12 status portal."
  type        = number
  default     = 8080
}

variable "adminer_port" {
  description = "Host port for the Adminer database interface."
  type        = number
  default     = 8081
}

variable "postgres_db" {
  description = "Name of the PostgreSQL database initialized on first startup."
  type        = string
  default     = "helpdesk"
}

variable "postgres_user" {
  description = "PostgreSQL user initialized on first startup."
  type        = string
  default     = "student"
}

variable "postgres_password" {
  description = "Local lab database password; supply through ignored terraform.tfvars."
  type        = string
  sensitive   = true
}
