variable "table_name" {
    description = "Lock table name"
    type = string
    default = "terraform-locks-table"
}
variable "hash_key" {
    description = "Lock table name"
    type = string
    default = "LockID"
}

variable "lock_table_tag" {
  type        = string
  default     = "Lock_table_tag"
  description = "tag for lock table"
}
