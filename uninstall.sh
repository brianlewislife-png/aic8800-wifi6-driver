#!/bin/bash
# =====================================================================
# CREDITOS OBRIGATORIOS (nao remover):
# Autor: Brian Lewis
# GitHub: github.com/brianlewislife-png | LinkedIn: linkedin.com/in/brian-lewis-4ba63739a
# Telegram: t.me/brianlewisdev | Instagram: instagram.com/Brian_lewis_2
# YouTube: youtube.com/@brianlewisdeveloper | Canal Zap: whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
# X/Twitter e Reddit: links oficiais em breve
# Detalhes: veja arquivo CREDITS.md
# =====================================================================
# uninstall.sh - Remove o driver AIC8800 WiFi 6
set -eE
set -o pipefail

if [ "$EUID" -ne 0 ]; then echo "Execute como root: sudo $0"; exit 1; fi

DRV_NAME="aic8800"
DRV_VERSION="1.0.0"
SRC_DIR="/usr/src/${DRV_NAME}-${DRV_VERSION}"

echo "=== Removendo driver AIC8800 ==="

# 1. Unload modules (best-effort)
echo "[1/8] Descarregando módulos..."
modprobe -r aic8800_fdrv 2>/dev/null || true
modprobe -r aic_load_fw 2>/dev/null || true
modprobe -r aic_zlp_quirk 2>/dev/null || true

# 2. Remove superseded test packages
echo "[2/8] Removendo pacotes de teste superseded..."
for legacy_package in "btusb-aic-zlp/0.1" "aic-zlp-quirk/0.1"; do
    if dkms status 2>/dev/null | grep -q "^${legacy_package},"; then
        dkms remove "$legacy_package" --all >> /dev/null 2>&1 || true
    fi
done

# 3. Remove DKMS module
echo "[3/8] Removendo módulo DKMS..."
if dkms status 2>/dev/null | grep -q "${DRV_NAME}/${DRV_VERSION}"; then
    dkms remove "${DRV_NAME}/${DRV_VERSION}" --all 2>&1 || true
fi

# 4. Remove source directory
echo "[4/8] Removendo código fonte..."
if [ -d "$SRC_DIR" ]; then
    rm -rf "$SRC_DIR"
fi

# 5. Remove firmware
echo "[5/8] Removendo firmware..."
rm -rf /lib/firmware/aic8800* 2>/dev/null || true
rm -rf /usr/lib/firmware/aic8800* 2>/dev/null || true

# 6. Remove udev rules and helper
echo "[6/8] Removendo regras udev e helper..."
rm -f /usr/lib/udev/rules.d/aic.rules 2>/dev/null || true
rm -f /etc/udev/rules.d/aic.rules 2>/dev/null || true
rm -rf /usr/lib/aic8800 2>/dev/null || true
udevadm control --reload-rules 2>/dev/null || true
udevadm trigger 2>/dev/null || true

# 7. Remove modprobe config, usb_modeswitch, legacy configs
echo "[7/8] Removendo configurações..."
rm -f /etc/modprobe.d/aic8800.conf 2>/dev/null || true
rm -f /etc/usb_modeswitch.d/1111:1111 2>/dev/null || true
rm -f /etc/modprobe.d/aic8800-bt.conf 2>/dev/null || true
rm -f /etc/udev/rules.d/90-aic8800-mode-switch.rules 2>/dev/null || true
rm -f /etc/modprobe.d/aic8800-bt.conf.aic8800-backup 2>/dev/null || true
rm -f /etc/udev/rules.d/90-aic8800-mode-switch.rules.aic8800-backup 2>/dev/null || true

# 8. Refresh initramfs and depmod
echo "[8/8] Atualizando initramfs e dependências..."
if command -v update-initramfs > /dev/null 2>&1; then
    update-initramfs -u -k "$(uname -r)" 2>/dev/null || true
elif command -v dracut > /dev/null 2>&1; then
    dracut -f 2>/dev/null || true
fi
depmod -a 2>/dev/null || true

# Remove log file
rm -f /var/log/aic8800-install.log 2>/dev/null || true

echo ""
echo "=== Desinstalação concluída ==="
echo "Reinicie o sistema se necessário."
echo ""
echo "Créditos: Brian Lewis (github.com/brianlewislife-png)"