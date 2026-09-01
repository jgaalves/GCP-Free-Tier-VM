# GCP Free-Tier VM

Provisiona uma instância `e2-micro` (Always Free) no GCP, com VPC customizada,
firewall restrita a IPs específicos e IP externo estático.

**Objetivo:** hospedar o BookOrbit rodando via Docker nessa instância.

## Recursos criados

- VPC customizada + subnet
- Firewall rules (SSH na porta 22, web/observabilidade nas portas 80/3000/9090/9100),
  restritas aos IPs definidos em `allowed_cidrs`
- IP externo estático
- Instância `e2-micro` com Docker instalado via startup-script

## Usando essa budega

1. Copie o arquivo de exemplo e preencha com seus valores reais:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edite `terraform.tfvars`:
   - `project_id`: seu projeto no GCP
   - `allowed_cidrs`: lista de IPs autorizados 
   - `ssh_public_key`: conteúdo da sua chave pública SSH

3. Autentique o `gcloud` e o Terraform:
   ```bash
   gcloud auth application-default login
   gcloud config set project SEU-PROJECT-ID
   gcloud services enable compute.googleapis.com
   ```

4. Aplique:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. Conecte:
   ```bash
   ssh -i ~/.ssh/id_ed25519 estudo@$(terraform output -raw instance_external_ip)
   ```

## Importante
- Elegibilidade Always Free depende da região: use `us-west1`, `us-central1` ou `us-east1`.