variable "applications" {
  type = map(object({
    dynamodb_tables                = list(string)
    dynamo_db_policy_json_tpl_path = string
    arn                            = string
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