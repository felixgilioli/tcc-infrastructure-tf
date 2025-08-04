# Terraform TCC Fiap - Infraestrutura serviço de Fast Food

## Descrição

Este projeto utiliza o Terraform para provisionar de forma automatizada e segura todos os recursos necessários para a criação de um ambiente completo na AWS. Ele é responsável por:

* Provisionar um cluster Kubernetes gerenciado (EKS);
* Criar uma instância de banco de dados PostgreSQL utilizando o Amazon RDS;
* Armazenar o estado do Terraform em um bucket S3, garantindo versionamento e controle de mudanças na infraestrutura.

O objetivo é facilitar a criação, gerenciamento e destruição de ambientes Kubernetes para desenvolvimento, testes ou produção, promovendo consistência e reprodutibilidade na infraestrutura.

## Estrutura do Projeto

A infraestrutura é organizada em módulos reutilizáveis, facilitando a manutenção e a escalabilidade. A seguir, a estrutura principal:

```
src/
  main.tf                # Arquivo principal que orquestra os módulos
  variables.tf           # Variáveis globais
  outputs.tf             # Saídas globais
  provider.tf            # Configuração do provedor AWS
  locals.tf              # Definições locais
  modules/
    eks/                 # Módulo para provisionamento do EKS
      main.tf
      variables.tf
      outputs.tf
      iam.tf
    networking/          # Módulo para rede (VPC, subnets, security groups)
      main.tf
      variables.tf
      outputs.tf
      security_groups.tf
    rds/                 # Módulo para banco de dados RDS PostgreSQL
      main.tf
      variables.tf
      outputs.tf
```

### Descrição dos Módulos

- **networking**: Cria a VPC, subnets públicas/privadas e security groups necessários para a comunicação segura entre os recursos.
- **eks**: Provisiona o cluster Kubernetes gerenciado (EKS), incluindo roles e policies de IAM.
- **rds**: Cria a instância do banco de dados PostgreSQL no Amazon RDS, configurando parâmetros de segurança e acesso.

### Armazenamento do Estado

O estado do Terraform é armazenado remotamente em um bucket S3, com versionamento habilitado, garantindo segurança e rastreabilidade das mudanças.

### Scripts Auxiliares

- `scripts/setup-terraform-backend.sh`: Automatiza a configuração inicial do backend remoto no S3.
- `scripts/cleanup-terraform-backend.sh`: Remove os recursos do backend remoto, se necessário.

## Execução Automatizada com GitHub Actions

A execução do Terraform está totalmente automatizada utilizando o GitHub Actions. O pipeline é acionado automaticamente a cada push na branch `main` e realiza as seguintes etapas:

### Etapas do Pipeline

1. **terraform-scan**
   - **Checkout:** Clona o repositório.
   - **Setup Terraform:** Instala a versão especificada do Terraform.
   - **Terraform Init:** Inicializa o diretório de trabalho do Terraform.
   - **Terraform Validate:** Valida a configuração dos arquivos Terraform.
   - **Terraform Plan:** Gera o plano de execução e exporta para JSON.
   - **TFLint:** Instala e executa o TFLint para análise estática dos arquivos Terraform.
   - **Trivy Scan:** Executa o Trivy para análise de segurança do plano gerado.
   - **Publicação de Relatórios:** Publica os resultados do TFLint e Trivy no summary do GitHub Actions.

2. **terraform-exec** (executado após sucesso do scan)
   - **Checkout:** Clona o repositório.
   - **Setup Terraform:** Instala a versão especificada do Terraform.
   - **Terraform Init:** Inicializa o diretório de trabalho do Terraform.
   - **Terraform Validate:** Valida a configuração dos arquivos Terraform.
   - **Terraform Apply:** Aplica as mudanças automaticamente na infraestrutura.

Essas etapas garantem validação, segurança e aplicação automatizada da infraestrutura, promovendo boas práticas de DevOps e IaC.

## Arquitetura Geral

A arquitetura provisionada segue o padrão de microsserviços, com um cluster EKS para orquestração de containers, banco de dados gerenciado e rede isolada. O acesso é controlado por security groups e roles de IAM, promovendo segurança e boas práticas de DevOps.
