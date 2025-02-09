# Création de la clé SSH
# resource "aws_key_pair" "bastion_key" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }

# Génération de la paire de clés SSH
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Écrire la clé privée dans un fichier local
resource "local_file" "ssh_private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/generated-keys/id_rsa"
}

resource "local_file" "ssh_public_key" {
  content  = tls_private_key.my_key.public_key_openssh
  filename = "${path.module}/generated-keys/id_rsa.pub"
}

# Création de la clé SSH dans AWS
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Security Group pour le bastion
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Création de l'Instance Bastion et provisionnement avec Ansible
resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnets[0]
  key_name                    = aws_key_pair.bastion_key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.my_key.private_key_pem
    }
  }
 
  provisioner "local-exec" {
    command = <<EOT
      chmod 400 ${path.module}/generated-keys/id_rsa
    EOT
  }
  provisioner "local-exec" {
    command = <<EOT
      chmod 400 ${path.module}/generated-keys/id_rsa
      VAULT_PASSWORD_FILE=$(mktemp)
      echo "$VAULT_PASSWORD" > "$VAULT_PASSWORD_FILE"
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip}', --private-key ${path.module}/generated-keys/id_rsa --ssh-common-args='-o IdentitiesOnly=yes' ${path.module}/ansible/provision_bastion.yml -e ${path.module}/ansible/vars-vault.yml -e ${path.module}/ansible/vars-ingress.yml -e 'cluster_name=${var.cluster_name} region=${var.region} ansible_user=ubuntu' --vault-password-file "$VAULT_PASSWORD_FILE" -vv
      rm -f "$VAULT_PASSWORD_FILE"
    EOT
  }
  tags = {
    Name = "BastionHost"
  }
}

# Outputs
output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

# Security Group pour autoriser le trafic entrant sur le cluster depuis le bastion
resource "aws_security_group_rule" "allow_https" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = var.cluster_security_group_id
  source_security_group_id = aws_security_group.bastion_sg.id
}