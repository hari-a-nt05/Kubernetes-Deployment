variable "db_name" {
  description = "Database name"
  type        = string
  default     = "haridb"
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "hariadmin"
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}
