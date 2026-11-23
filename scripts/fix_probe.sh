#!/bin/bash
# fix_probe.sh - Corrige o erro "probe failed with error -1" / "bin upload fail"
# Causas comuns: firmware ausente, caminho errado, arquivo .bin faltando
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Execute como root: sudo $0"; exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FW_SRC="${SCRIPT_DIR}/fw/aic8800DC"
FW_DST="/usr/lib/firmware/aic8800DC"

echo "==> Garantindo pasta de firmware..."
mkdir -p /usr/lib/firmware

echo "==> Copiando firmware DC..."
rm -rf "$FW_DST"
cp -r "$FW_SRC" "$FW_DST"

echo "==> Criando fmacfw_patch_8800dc.bin (baseado em _u02)..."
cp "$FW_DST/fmacfw_patch_8800dc_u02.bin" "$FW_DST/fmacfw_patch_8800dc.bin" 2>/dev/null || true

echo "==> Copiando firmware para /lib/firmware (alias)..."
mkdir -p /lib/firmware
cp -r "$FW_DST" /lib/firmware/ 2>/dev/null || true

echo "==> Recarregando módulos..."
modprobe -r aic8800_fdrv 2>/dev/null || true
modprobe -r aic_load_fw 2>/dev/null || true
sleep 1
modprobe aic_load_fw aic_fw_path=/usr/lib/firmware
sleep 1
modprobe aic8800_fdrv
sleep 3

echo "==> Resultado:"
ip link show | grep -iE "wl|wlan" && echo "SUCESSO: interface WiFi detectada!" || echo "AVISO: nenhuma interface WiFi. Verifique dmesg."
echo "aic_fw_path: $(cat /sys/module/aic_load_fw/parameters/aic_fw_path)"
echo "Logs: dmesg | grep -iE 'aic8800|fmacfw|bin upload|probe'"
