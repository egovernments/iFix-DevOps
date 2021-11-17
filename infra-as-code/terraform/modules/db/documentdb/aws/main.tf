resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group-${var.environment}"
  subnet_ids = "${var.subnet_ids}"

    tags = "${
    map(
      "Name", "db-subnet-group-${var.environment}",
      "environment", "${var.environment}"
    )
  }"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${var.cluster_name}-db-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "${var.instance_class}"
}

resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  family      = "docdb4.0"
  name        = "${var.cluster_name}-db"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = "${var.cluster_name}-db"
  master_username                 = "${var.administrator_login}"
  master_password                 = "${var.administrator_login_password}"
  backup_retention_period         = "${var.backup_retention_days}"
  vpc_security_group_ids          = "${var.vpc_security_group_ids}"
  db_subnet_group_name            = "${aws_db_subnet_group.db_subnet_group.name}"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.parameter_group.name}"
  engine                          = "docdb"
  engine_version                  = "${var.engine_version}"
}