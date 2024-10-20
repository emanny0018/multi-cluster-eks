terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "${terraform.workspace}/terraform.tfstate"  # Workspace-specific state file
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

