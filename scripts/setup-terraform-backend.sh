#!/bin/bash

# Configurações
BUCKET_NAME="iac-tcc-felix"
REGION="us-east-1"
DYNAMODB_TABLE="tcc-locks"

# Criar bucket S3
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

# Habilitar versionamento no bucket
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Criar tabela DynamoDB com a chave primária correta
aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $REGION

# Aguardar a tabela ficar ativa
echo "Aguardando a tabela DynamoDB ficar ativa..."
aws dynamodb wait table-exists \
  --table-name $DYNAMODB_TABLE \
  --region $REGION

echo "Backend configurado com sucesso!" 