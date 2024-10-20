terraform {
  backend "s3" {
    bucket         = "etl-pipeline-manny"
    key            = "${terraform.workspace}/terraform.tfstate"  # Workspace-specific state file
    region         = "us-east-2"
    dynamodb_table = "tf_state_lock"
    encrypt        = true
  }
}

