variable "project_id" {
  description = "ID do projeto no GCP"
  type        = string
}

variable "region" {
  description = "Região elegível para o Always Free (ex: us-west1, us-central1, us-east1)"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "Zona dentro da região (ex: us-east1-b)"
  type        = string
  default     = "us-east1-b"
}

variable "network_name" {
  description = "Prefixo usado nos nomes da rede, subnet e firewall"
  type        = string
  default     = "lab"
}

variable "subnet_cidr" {
  description = "CIDR da subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "instance_name" {
  description = "Nome da instância"
  type        = string
  default     = "yorha-type-2"
}

variable "my_ip_cidr" {
  description = "Seu IP público em formato CIDR, ex: 200.100.50.10/32 (descubra em https://ifconfig.me)"
  type        = string
}

variable "ssh_user" {
  description = "Usuário SSH que será criado na instância"
  type        = string
  default     = "A2"
}

variable "ssh_public_key" {
  description = "Conteúdo da sua chave pública SSH (ex: cat ~/.ssh/id_ed25519.pub)"
  type        = string
}

variable "startup_script" {
  description = "Script executado na primeira inicialização (equivalente ao user_data da AWS)"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
  EOT
}
