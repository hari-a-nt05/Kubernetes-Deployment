variable "db_name" {
  default = "haridb"
  description = "Database name"
  type        = string
}

variable "db_username" {
  default = "hariadmin"
  description = "Master DB username"
  type        = string
}

variable "db_password" {
  default = "hari2415"
  description = "Master DB password"
  type        = string
  sensitive   = true
}
