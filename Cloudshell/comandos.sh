#!/bin/bash

# Variáveis de ambiente - Edite conforme necessário
export STACK_NAME=lab-cicd-stack
export REPO_NAME=flask-cicd-repo
export BUCKET_NAME=fernando-artefatos
export INSTANCE_NAME=FlaskInstance-fernando
export APP_NAME=flask-cicd-app
export BUILD_PROJECT_NAME=flask-cicd-build
export KEY_NAME=fernando-cicd
export INSTANCE_TYPE=t2.micro # Não Alterar
export AWS_PAGER="" # Não Alterar

echo "===== 1. Criando bucket S3 para artefatos (se não existir) ====="
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket $BUCKET_NAME já existe."
else
  aws s3 mb s3://$BUCKET_NAME
fi

echo "===== 2. Criando chave SSH (se não existir) ====="
if aws ec2 describe-key-pairs --key-names "$KEY_NAME" &>/dev/null; then
  echo "Chave $KEY_NAME já existe."
else
  aws ec2 create-key-pair --key-name "$KEY_NAME"     --query 'KeyMaterial'     --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
  echo "Chave criada e salva como $KEY_NAME.pem"
fi

echo "===== 3. Verificando AMI de acordo com região ====="
AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023.7.20250609.0-kernel-6.1-x86_64" \
  --query "Images[0].ImageId" \
  --output text)

echo "===== 4. Criando stack CloudFormation ====="
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://Infraestrutura/cloudformation.yml \
  --parameters \
    ParameterKey=RepoName,ParameterValue=$REPO_NAME \
    ParameterKey=ArtifactBucket,ParameterValue=$BUCKET_NAME \
    ParameterKey=AppName,ParameterValue=$APP_NAME \
    ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME \
    ParameterKey=BuildProjectName,ParameterValue=$BUILD_PROJECT_NAME \
    ParameterKey=AmiId,ParameterValue=$AMI_ID \
    ParameterKey=KeyName,ParameterValue=$KEY_NAME \
    ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
  --capabilities CAPABILITY_NAMED_IAM

echo "===== 5. Aguardando criação da stack ====="
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
STATUS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].StackStatus" --output text)

if [[ "$STATUS" == "ROLLBACK_COMPLETE" || "$STATUS" == "ROLLBACK_IN_PROGRESS" ]]; then
  echo "❌ Stack entrou em rollback. Deletando..."
  aws cloudformation delete-stack --stack-name $STACK_NAME
  echo "Stack $STACK_NAME removida devido a falha de criação."
  exit 1
else
  echo "✅ Stack criada com sucesso! Status: $STATUS"
fi