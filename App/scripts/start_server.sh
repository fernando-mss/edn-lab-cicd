#!/bin/bash

APP_DIR="/home/ec2-user/app"
LOG_FILE="$APP_DIR/app.log"
ERROR_FILE="$APP_DIR/error.log"
DEPLOY_LOG="$APP_DIR/deploy.log"

echo "[DEBUG] Executado como: $(whoami)" >> "$DEPLOY_LOG"

cd "$APP_DIR" || {
  echo "❌ Diretório $APP_DIR não encontrado" >> "$DEPLOY_LOG"
  exit 1
}

echo "[INFO] Encerrando processos antigos na porta 5000..." >> "$DEPLOY_LOG"
PID=$(lsof -t -i:5000)
if [ -n "$PID" ]; then
  kill -9 "$PID"
  echo "[INFO] Processo antigo $PID finalizado." >> "$DEPLOY_LOG"
else
  echo "[INFO] Nenhum processo antigo rodando na porta 5000." >> "$DEPLOY_LOG"
fi

echo "[INFO] Iniciando aplicação Flask..." >> "$DEPLOY_LOG"
nohup python3 app.py >> "$LOG_FILE" 2>> "$ERROR_FILE" &

sleep 5

curl -s http://localhost:5000 > /dev/null
if [ $? -eq 0 ]; then
  echo "[OK] Aplicação respondendo na porta 5000" >> "$DEPLOY_LOG"
else
  echo "[ERRO] Aplicação não respondeu na porta 5000 após 5s" >> "$DEPLOY_LOG"
  exit 1
fi
