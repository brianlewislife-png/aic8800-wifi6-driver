#!/bin/bash
# =====================================================================
# CREDITOS OBRIGATORIOS (nao remover):
# Autor: Brian Lewis
# GitHub: github.com/brianlewislife-png | LinkedIn: linkedin.com/in/brian-lewis-4ba63739a
# Telegram: t.me/brianlewisdev | Instagram: instagram.com/Brian_lewis_2 | YouTube: youtube.com/@brianlewisdeveloper | Canal Zap: whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
# Canal Zap: https://www.whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
# X/Twitter e Reddit: links oficiais em breve
# Detalhes: veja arquivo CREDITS.md
# =====================================================================
# uninstall.sh - Remove o driver AIC8800 WiFi 6
set -e
if [ "$EUID" -ne 0 ]; then echo "Execute como root: sudo $0"; exit 1; fi
DRV_NAME="aic8800"; DRV_VERSION="1.0.0"
echo "Removendo driver AIC8800..."
dkms remove "${DRV_NAME}/${DRV_VERSION}" --all 2>/dev/null || true
rm -rf /lib/firmware/aic8800*
rm -f /usr/lib/udev/rules.d/aic.rules
rm -rf /usr/src/${DRV_NAME}-${DRV_VERSION}
udevadm control --reload-rules 2>/dev/null || true
depmod -a 2>/dev/null || true
echo "Remocao concluida. Reinicie se necessario."
