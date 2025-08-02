#!/bin/bash

# Configurações (mesmas do script de setup)
BUCKET_NAME="iac-terraform-felix"
REGION="us-east-1"
DYNAMODB_TABLE="terraform-locks"

# Remover todas as versões dos objetos do bucket S3
echo "Removendo todas as versões dos objetos do bucket S3..."
aws s3api list-object-versions \
  --bucket $BUCKET_NAME \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' \
  --output json | \
  jq -r '.[] | "\(.Key) \(.VersionId)"' | \
  while read -r key version; do
    if [ "$version" != "null" ]; then
      aws s3api delete-object \
        --bucket $BUCKET_NAME \
        --key "$key" \
        --version-id "$version"
    fi
  done

# Remover todos os delete markers
echo "Removendo delete markers..."
aws s3api list-object-versions \
  --bucket $BUCKET_NAME \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' \
  --output json | \
  jq -r '.[] | "\(.Key) \(.VersionId)"' | \
  while read -r key version; do
    if [ "$version" != "null" ]; then
      aws s3api delete-object \
        --bucket $BUCKET_NAME \
        --key "$key" \
        --version-id "$version"
    fi
  done

# Deletar o bucket S3
echo "Deletando bucket S3..."
aws s3api delete-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

# Deletar a tabela DynamoDB
echo "Deletando tabela DynamoDB..."
aws dynamodb delete-table \
  --table-name $DYNAMODB_TABLE \
  --region $REGION

# Aguardar a tabela ser deletada
echo "Aguardando a tabela DynamoDB ser deletada..."
aws dynamodb wait table-not-exists \
  --table-name $DYNAMODB_TABLE \
  --region $REGION

echo "Recursos removidos com sucesso!" 