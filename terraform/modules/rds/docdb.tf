# # Déclaration du cluster DocumentDB
# resource "aws_docdb_cluster" "docdb_cluster" {
#   engine         = "docdb"
#   cluster_identifier = "docdb-cluster-${var.subnet_group_name}"
#   master_username    = var.db_instance_username
#   master_password    = random_password.password.result
#   db_subnet_group_name = aws_docdb_subnet_group.docdb_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.docdb_sg.id]
#   skip_final_snapshot = true
  
#   backup_retention_period = 7
#   preferred_backup_window = "07:00-09:00"

#   tags = {
#     Name = "mydocdbcluster"
#   }
# }

# # Instances DocumentDB associées au cluster
# resource "aws_docdb_cluster_instance" "docdb_instance" {
#   count            = 2
#   identifier       = "docdb-instance-${count.index}"
#   cluster_identifier = aws_docdb_cluster.docdb_cluster.id
#   instance_class   = var.docdb_instance_class

#   apply_immediately = true

#   tags = {
#     Name = "mydocdbinstance-${count.index}"
#   }
# }

# # Groupe de sous-réseaux DocumentDB
# resource "aws_docdb_subnet_group" "docdb_subnet_group" {
#   name       = "${var.subnet_group_name}-subnet-group"
#   subnet_ids = var.private_subnets

#   tags = {
#     Name = "${var.subnet_group_name}-subnet-group"
#   }
# }

# # Génération de mot de passe sécurisé pour DocumentDB
# resource "random_password" "password" {
#   length           = 12
#   min_lower        = 3
#   min_numeric      = 3
#   min_upper        = 3
# }

# # Groupe de sécurité pour DocumentDB
# resource "aws_security_group" "docdb_sg" {
#   name        = "${var.subnet_group_name}-docdb-sg"
#   description = "DocumentDB security group for ${var.subnet_group_name}"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 27017  # Port standard MongoDB / DocumentDB
#     to_port     = 27017
#     protocol    = "tcp"
#     security_groups = var.eks_cluster_security_group_id
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.subnet_group_name}-docdb-sg"
#   }
# }
