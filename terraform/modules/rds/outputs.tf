# output "db_name" {
#   value = aws_db_instance.db_instance[0].db_name
# }

# output "docdb_cluster_username" {
#   value = aws_db_instance.db_instance[0].username
# }

# output "docdb_cluster_password" {
#   value = random_password.password.result
# }

# output "docdb_cluster_endpoint" {
#   value = aws_db_instance.db_instance[0].endpoint
# }

# output "docdb_cluster_endpoint" {
#   value = aws_docdb_cluster.docdb_cluster.endpoint
# }

# output "docdb_cluster_port" {
#   value = aws_docdb_cluster.docdb_cluster.port
# }

# output "docdb_cluster_username" {
#   value = aws_docdb_cluster.docdb_cluster.master_username
#   sensitive = true
# }

# output "docdb_cluster_password" {
#   value = random_password.password.result
#   sensitive = true
# }