provider "aws" {
    region  = "us-east-2"
    profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "tmnkun-tf-up-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-up-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" { 
  identifier_prefix = "tf-up"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"

  password          = var.db_pasword

}
