# resource "aws_db_instance" "db_instance" {
#   count = 2
#   engine                  = var.engine
#   engine_version          = var.engine_version
#   multi_az                = true
#   identifier              = "db-instance-${count.index}"
#   username                = var.db_instance_username
#   password                = random_password.password.result
#   instance_class          = var.instance_class
#   allocated_storage       = var.db_instance_allocated_storage
#   db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
#   vpc_security_group_ids  = [aws_security_group.rds_sg.id]
# #   db_name                 = var.db_name
#   skip_final_snapshot     = true
#   publicly_accessible  = var.publicly_accessible
#   parameter_group_name = var.parameter_group_name
#   tags = {
#     Name = "mydbinstance-${count.index}"
#   }
# }


# resource "aws_db_subnet_group" "database_subnet_group" {
#   name       = "${var.subnet_group_name}-subnet-group"
#   subnet_ids = var.private_subnets
# }

# resource "random_password" "password" {
#   length           = 20
#   min_lower = "3"
# #  min_numeric = "3"
#   min_upper = "3"
# }


# resource "aws_security_group" "rds_sg" {
#   name        = "${var.subnet_group_name}-rds-sg"
#   description = "RDS security group for ${var.subnet_group_name}"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = var.db_port
#     to_port     = var.db_port
#     protocol    = "tcp"
#     security_groups = var.eks_cluster_security_group_id
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

