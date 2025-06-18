# Documentação Final do Laboratório CI/CD com Flask na AWS

Este é um laboratório prático não oficial, desenvolvido exclusivamente para fins educacionais pelo instrutor Fernando Moreira. O conteúdo orienta o aluno passo a passo na implantação de uma aplicação Flask simples utilizando os serviços AWS CodeCommit, CodeBuild, CodeDeploy, CodePipeline e EC2, com toda a infraestrutura provisionada via CloudFormation (IaC).
O objetivo deste exercício é proporcionar uma experiência completa de CI/CD com automação, deploy contínuo e rollback controlado, preparando o aluno para aplicar esses conceitos em ambientes reais.

---

## Arquivos utilizados

Estrutura do projeto:

```
├── app.py                       # Aplicativo Flask principal
├── app.py.falha                 # Versão com erro proposital para simular rollback
├── appspec.yml                  # Script de deploy do CodeDeploy
├── buildspec.yml                # Script de build do CodeBuild
├── requirements.txt             # Dependências da aplicação
├── scripts/
│   └── start_server.sh          # Script para iniciar a aplicação na EC2
└── cloudformation/
    └── infra-flask-cicd.yml     # Template CloudFormation com toda infraestrutura
```

---

## Requisitos

- AWS CLI configurado (`aws configure`)
- Chave `.pem` correspondente à instância EC2

---

## Etapas do Laboratório

### 1. Criar bucket S3 e subir o código empacotado (flask-cicd.zip)
```bash
aws s3api create-bucket \
  --bucket seunome-cicd-bucket \
  --create-bucket-configuration LocationConstraint=sa-east-1
```
```bash
aws s3 cp flask-cicd.zip s3://seunome-cicd-bucket/
```

### 2. Deploy da infraestrutura via CloudFormation
```bash
aws cloudformation deploy   --template-file infra-flask-cicd.yml   --stack-name seunome-cicd-stack   --capabilities CAPABILITY_NAMED_IAM   --parameter-overrides InstanceType=t2.micro
```

### 3. Clonar repositório e enviar o código para CodeCommit (Acessem o serviço do CodeCommit para verificarem a url correta para clone do repositório)
```bash
git clone https://git-codecommit.<regiao>.amazonaws.com/v1/repos/seunome-flask-cicd-repo
cd seunome-flask-cicd-repo
unzip ../flask-cicd.zip -d .
git add .
git commit -m "Deploy inicial"
git push origin main
```

### 4. Acompanhar a execução do pipeline

- Acesse o [AWS CodePipeline Console](https://console.aws.amazon.com/codepipeline)
- Verifique os estágios `Source`, `Build`, `Deploy`

### 5. Validar execução na EC2
```bash
ssh -i seunome.pem ec2-user@<IP_PUBLICO_DA_EC2>
cd /home/ec2-user/flask-cicd
bash scripts/start_server.sh
curl localhost:5000
```

Verificar logs:
```bash
tail -f deploy.log
```

### 6. Validar acesso externo

No navegador:
```
http://<IP_PUBLICO_DA_EC2>:5000
```

Certifique-se de que a porta 5000 está liberada no Security Group.

---

## Simulando Rollback

### Para simular um deploy com erro:

1. Substitua `app.py` por `app.py.falha`:
```bash
cp app.py.falha app.py
```

2. Commit e push:
```bash
git add app.py
git commit -m "Simulando falha para rollback"
git push origin main
```

3. O CodeDeploy tentará fazer o deploy, falhará, e fará rollback automaticamente (se configurado).

---

## Recursos de destaque do projeto

- Infraestrutura como código (IaC) via CloudFormation
- CI/CD com serviços nativos AWS
- Deploy automatizado com rollback
- Script de inicialização robusto com logs e instalação de dependências

---

## Para ensino e extensão

- Reproduza com aplicações Flask, Node.js ou Django
- Teste substituindo EC2 por ECS ou Lambda
- Adicione testes automatizados no `buildspec.yml`
- Demonstre blue/green deploy com CodeDeploy

---

## Dúvidas?

Entre em contato pelo WhatsApp: **11957661999**

