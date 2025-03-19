provider "aws" {
  region  = "us-east-1"
  profile = "lfproduct-dev"
}

variable "app_name" {
  default = "lf-dev-gerrit-server"
}
