resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.project_name}/database-credentials"
  description = "Database credentials for ${var.project_name}"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}