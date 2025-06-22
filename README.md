# Projeto de Laboratório CI/CD com AWS

Este projeto implementa uma pipeline CI/CD completa utilizando os seguintes serviços da AWS:

- AWS CodeCommit
- AWS CodeBuild
- AWS CodeDeploy
- AWS CodePipeline
- Amazon EC2
- Amazon S3
- AWS CloudFormation

---

## Etapas Automatizadas pelo Script

O script `Cloudshell/comandos.sh` realiza automaticamente:

1. Criação do bucket S3 (se não existir)
2. Criação da chave SSH (se não existir)
3. Verificação da AMI recomendada
4. Upload do artefato para o S3
5. Criação da stack via CloudFormation
6. Espera da conclusão (`CREATE_COMPLETE`)
7. Deleção automática da stack caso entre em `ROLLBACK_COMPLETE`

---

## Estrutura dos arquivos

O `.zip` do projeto contém:

```
lab-cicd/
├── App/
│   ├── app.py
│   ├── requirements.txt
│   ├── buildspec.yml
│   ├── appspec.yml
│   └── scripts/
│       ├── install_dependencies.sh
│       ├── start_server.sh
│       └── validate_service.sh
├── Infraestrutura/
│   └── cloudformation.yml
├── Cloudshell/
│   └── comandos.sh
```

---

## Execução do Deploy

### 1. Acesse o CloudShell
https://console.aws.amazon.com/cloudshell

### 2. Faça upload do arquivo `lab-cicd.zip`

### 3. Extraia e acesse o diretório
```bash
unzip lab-cicd.zip
cd lab-cicd
```

### 4. Torne o script executável e execute
```bash
chmod +x Cloudshell/comandos.sh
./Cloudshell/comandos.sh
```

---

## Push manual para o CodeCommit

Após a stack estar criada:

```bash
git clone https://git-codecommit.sa-east-1.amazonaws.com/v1/repos/flask-cicd-repo #Altere de acordo com a URL disponibilizada no seu codfe commit
git config --global user.email "seunome@email.com"
git config --global user.name "Fulano Detal"
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
cd flask-cicd-repo
cp -r ../App/* .
git add .
git commit -m "Versão inicial"
git branch -M main
git remote add origin https://git-codecommit.sa-east-1.amazonaws.com/v1/repos/flask-cicd-repo #Altere de acordo com a URL disponibilizada no seu codfe commit
git push -u origin main
```

## Acesse sua aplicação:

```bash
aws ec2 describe-instances   --filters "Name=tag:Name,Values=FlaskInstance-fernando"   --query "Reservations[*].Instances[*].PublicIpAddress"   --output text
```

Acesse no navegador:
```
http://<IP>:5000
```

---

---

## Teste de rollback automático

### Simular erro na pipeline:
```bash
echo "return x" >> app.py
git add app.py
git commit -m "Simulando erro para rollback"
git push
```

### Corrigir erro e redeploy:
```bash
git checkout HEAD~1 app.py
git commit -am "Corrigido rollback"
git push
```

---

## Observações finais

- A stack será removida automaticamente se a criação falhar.
- O pipeline permite testes seguros de rollback.
- Ideal para treinamentos, provas de conceito e simulação de ambientes CI/CD reais.
