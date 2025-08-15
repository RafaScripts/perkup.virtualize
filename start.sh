#!/bin/bash

echo ">>> Iniciando o script de inicialização..."

# 1. Prepara a imagem do macOS (só precisa ser feito uma vez)
# Este comando baixa o instalador do macOS e cria o disco virtual.
# Pode levar MUITO tempo e consumir muitos dados na primeira execução.
if [ ! -f "macOS.qcow2" ]; then
    echo ">>> Imagem do macOS não encontrada. Criando uma nova..."
    # Usando a versão Monterey como exemplo.
    # O script 'make.sh' baixa os arquivos necessários.
    ./make.sh --version monterey
fi

# 2. Inicia a VM do macOS em segundo plano
echo ">>> Iniciando a VM do macOS em segundo plano..."
# Argumentos importantes:
# -vnc :99 -> Inicia um servidor VNC para a VM na porta 5999 (99 + 5900)
# -daemonize -> Roda a VM em segundo plano (headless)
./run.sh -vnc :99 -daemonize

# 3. Aguarda a VM inicializar e a porta VNC ficar disponível
echo ">>> Aguardando a porta VNC (5999) da VM ficar ativa..."
while ! nc -z 127.0.0.1 5999; do
  sleep 1 # espera 1 segundo antes de checar novamente
  echo ">>> Ainda esperando pela VM..."
done
echo ">>> VM detectada! Porta VNC está pronta."

# 4. Inicia o servidor KasmVNC
echo ">>> Iniciando o servidor KasmVNC para transmitir a sessão..."
# O KasmVNC lerá a configuração de /etc/kasmvnc/kasm_vnc.config
/usr/bin/kasmvncserver
