# Base Image: Ubuntu 22.04
FROM ubuntu:22.04

# Evita prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências para Docker-OSX e KasmVNC
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    python3 \
    python3-pip \
    git \
    wget \
    unzip \
    libpulse0 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Instala o KasmVNC
RUN wget https://github.com/kasmtech/KasmVNC/releases/download/v1.4.0/KasmVNC_1.4.0_ubuntu22_amd64.deb -O /tmp/kasmvnc.deb && \
    apt-get update && apt-get install -y /tmp/kasmvnc.deb && \
    rm /tmp/kasmvnc.deb && \
    rm -rf /var/lib/apt/lists/*

# Clona o repositório Docker-OSX
RUN git clone https://github.com/sickcodes/Docker-OSX.git /app/Docker-OSX

# Define o diretório de trabalho
WORKDIR /app/Docker-OSX

# Copia nossos scripts e configurações para dentro da imagem
COPY start.sh /app/start.sh
COPY kasm_vnc.config /etc/kasmvnc/kasm_vnc.config

# Garante que nosso script de inicialização seja executável
RUN chmod +x /app/start.sh

# Expõe a porta padrão do KasmVNC
EXPOSE 8443

# Define o comando que será executado quando o contêiner iniciar
CMD [ "/app/start.sh" ]
