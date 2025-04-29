locals {
  common_tags = {
    environment = var.environment
    managedBy   = var.team
    createdBy   = "terraform"
  }

  applications_data = flatten([
    for domain_name, domain_data in var.applications : [
      for table_name in domain_data.dynamodb_tables : {
        team                      = domain_name
        policy_json_tpl_file_path = domain_data.dynamo_db_policy_json_tpl_path
        table_name                = table_name
        arn                       = arn
      }
    ]
  ])
}

# Create DynamoDB table with deletion protection enabled
resource "aws_dynamodb_table" "this" {
  for_each = { for idx, value in local.applications_data : "${value.table_name}" => value }

  name         = each.key
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Enable Point-in-Time Recovery (deletion protection)
  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_resource_policy" "this" {
  for_each = { for idx, value in local.applications_data : "${value.table_name}" => value }

  resource_arn = aws_dynamodb_table.this[each.key].arn

  policy = templatefile("${each.value.policy_json_tpl_file_path}", {
    name = each.value.table_name
    arn  = each.value.arn
  })
}