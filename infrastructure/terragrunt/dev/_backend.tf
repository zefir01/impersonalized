# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "blablabla-terragrunt-state"
    dynamodb_table = "my-lock-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "eu-central-1"
  }
}
