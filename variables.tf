variable "applications" {
  type = map(object({
    dynamodb_tables           = list(string)
    policy_json_tpl_file_path = string
  }))
}

variable "region" {
  type        = string
  description = "region for bucket creation"
}


variable "environment" {
  type = string
}
variable "team" {
  type = string
}