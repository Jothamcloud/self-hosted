terraform {
  backend "s3" {
    bucket = "self-hosted-577932"
    key    = "self-hosted-terrform.tfstate"
    region = "us-east-1"
  }
}
