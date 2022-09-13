output "users" {
  value = [
  for k in module.iam_user : {
    region     = "eu-central-1"
    name       = k.iam_user_name
    pass       = k.iam_user_login_profile_password
    account_id = data.aws_caller_identity.current.account_id
    url        = "https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#home:"
  }
  ]
  sensitive = true
}