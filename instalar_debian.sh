#!/bin/bash
# =====================================================================
# CREDITOS OBRIGATORIOS (nao remover):
# Autor: Brian Lewis
# GitHub: github.com/brianlewislife-png | LinkedIn: linkedin.com/in/brian-lewis-4ba63739a
# Telegram: t.me/brianlewisdev | Instagram: instagram.com/Brian_lewis_2
# Canal Zap: https://www.whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
# X/Twitter e Reddit: links oficiais em breve
# Detalhes: veja arquivo CREDITS.md
# =====================================================================
# instalar_debian.sh - Instalacao completa em um clique (Debian/Ubuntu)
# Instala dependencias e roda o instalador DKMS.
set -e
if [ "$EUID" -ne 0 ]; then echo "Execute como root: sudo $0"; exit 1; fi
cd "$(dirname "$0")"
echo "==> Atualizando lista de pacotes..."
apt-get update
echo "==> Instalando dependencias..."
apt-get install -y dkms build-essential "linux-headers-$(uname -r)" mokutil eject usb-modeswitch
echo "==> Rodando instalador do driver..."
./install.sh
echo "==> Concluido. Verifique com: ./scripts/diagnostico.sh"
