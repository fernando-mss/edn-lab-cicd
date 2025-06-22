# Git Cheatsheet

Este guia resume os principais comandos do Git com explicações e exemplos.

---

## Configuração Inicial

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```
Define o nome e o e-mail usados nos commits.

```bash
git config --global credential.helper cache
```
Evita ter que digitar a senha toda hora (temporário).

---

## Iniciar um repositório

```bash
git init
```
Cria um repositório Git no diretório atual.

---

## Clonar um repositório

```bash
git clone <URL>
```
Clona um repositório remoto para o seu computador.

---

## Status e Histórico

```bash
git status
```
Mostra o estado dos arquivos (modificados, staged, etc).

```bash
git log
```
Mostra o histórico de commits.

```bash
git show <commit>
```
Exibe detalhes de um commit específico.

---

## Adicionar e Commitar

```bash
git add <arquivo>
git add .
```
Adiciona arquivos ao **staging area** (pronto para commit).

```bash
git commit -m "mensagem do commit"
```
Cria um snapshot do código.

---

## Trabalhando com Remotos

```bash
git remote -v
```
Lista os repositórios remotos configurados.

```bash
git push origin main
```
Envia as alterações locais para o repositório remoto.

```bash
git pull origin main
```
Atualiza o repositório local com mudanças do remoto.

---

## Branches

```bash
git branch
```
Lista branches existentes.

```bash
git branch <nome-da-branch>
```
Cria uma nova branch.

```bash
git checkout <nome-da-branch>
```
Troca para outra branch.

```bash
git switch <nome-da-branch>
```
Alternativa moderna ao checkout.

```bash
git merge <branch>
```
Mescla a branch mencionada na branch atual.

---

## Desfazendo e Corrigindo

```bash
git restore <arquivo>
```
Desfaz mudanças locais (não staged).

```bash
git reset HEAD <arquivo>
```
Remove o arquivo do staging.

```bash
git reset --hard
```
⚠️ Desfaz todas as alterações locais.

```bash
git revert <commit>
```
Cria um novo commit que desfaz outro commit.

---

## Tags

```bash
git tag <nome>
```
Cria uma tag (ex: versão).

```bash
git tag -a <nome> -m "mensagem"
```

```bash
git push origin <tag>
```

---

## Stash (Guardar alterações temporariamente)

```bash
git stash
```
Guarda alterações temporariamente.

```bash
git stash apply
```
Restaura alterações guardadas.

---

## Outros úteis

```bash
git diff
```
Mostra diferenças entre arquivos modificados.

```bash
git clean -f
```
Remove arquivos não versionados.

```bash
git blame <arquivo>
```
Mostra o autor de cada linha do arquivo.

---

## Dica final

Use `git status` com frequência. Ele é seu melhor amigo para saber o que está acontecendo no seu repositório.

---

**Criado para alunos da Escola da Nuvem | Curso AWS Developer Associate**