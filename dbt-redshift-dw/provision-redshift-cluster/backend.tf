terraform {
  backend "s3" {
    bucket = "resource-provisioning"
    region = "us-east-1"
    key = "dbt-redshift/redshift-cluster/terraform.tfstate"

  }
  }