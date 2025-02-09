# output "db_password" {
#   description = "Mot de passe de la base de données RDS"
#   value       = module.database.docdb_cluster_password
#   sensitive   = true  # Cela masquera la valeur dans les logs
# }

# output "db_endpoint" {
#   description = "Endpoint de la base de données RDS"
#   value       = module.database.docdb_cluster_endpoint
# }

# output "db_username" {
#   description = "Nom d'utilisateur de la base de données RDS"
#   value       = module.database.docdb_cluster_username
# }
