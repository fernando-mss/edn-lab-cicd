#!/bin/bash

LOG_FILE="/home/ec2-user/app/deploy.log"

echo "Validando aplicação..." | tee -a "$LOG_FILE"
echo "[DEBUG] Validação executada como: $(whoami)" >> "$LOG_FILE"

# Tenta se conectar por até 30 tentativas (1 minuto total)
for i in {1..30}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000)

  if [[ "$STATUS" == "200" ]]; then
    echo "[OK] Aplicação respondeu com HTTP 200 (tentativa $i)" | tee -a "$LOG_FILE"
    exit 0
  elif [[ "$STATUS" =~ ^[45] ]]; then
    echo "[ERRO] Aplicação respondeu com HTTP $STATUS (tentativa $i)" | tee -a "$LOG_FILE"
    exit 1
  else
    echo "Aguardando aplicação subir ($i/30)..." | tee -a "$LOG_FILE"
    sleep 2
  fi
done

echo "[ERRO] Aplicação não respondeu dentro do tempo esperado." | tee -a "$LOG_FILE"
exit 1
