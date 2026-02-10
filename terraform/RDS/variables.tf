variable "db_name" {
  description = "Database name"
  type        = string
  default     = "hari-db"
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}
