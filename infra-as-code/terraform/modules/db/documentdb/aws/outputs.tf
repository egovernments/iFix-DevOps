output "mongo_uri" {
  value = "${aws_docdb_cluster.docdb.endpoint}"
}