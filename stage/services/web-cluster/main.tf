provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "webserver_cluster" {
  source                  = "../../../modules/services/webserver-cluster"

  cluster_name            = "webserver-stage"
  db_remote_state_bucket  = "tmnkun-tf-up-state"
  db_remote_state_key     = "stage/data-stores/mysql/terraform.tfstate"

  instance_type           = "t2.micro"
  min_size                = 2
  max_size                = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port         = 12345
  protocol          = "tcp"
  to_port           = 12345
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = module.webserver_cluster.alb_security_group_id
  type              = "ingress"

}
