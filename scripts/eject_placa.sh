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
# eject_placa.sh - Forca a troca da placa AIC8800 do modo pendrive para modo WiFi.
# Usa eject nos dispositivos sd* que tenham VID a69c (AICSemi).

set -u
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Execute como root: sudo $0${NC}"; exit 1
fi

echo "Procurando dispositivos AICSemi em modo pendrive (VID a69c)..."
found=0
for sysdev in /sys/block/sd*; do
    [ -d "$sysdev" ] || continue
    dev=$(basename "$sysdev")
    # percorre up tree para achar idVendor
    d="$sysdev"
    vid=""
    while [ "$d" != "/" ]; do
        if [ -f "$d/idVendor" ]; then
            vid=$(cat "$d/idVendor" 2>/dev/null)
            pid=$(cat "$d/idProduct" 2>/dev/null)
            break
        fi
        d=$(dirname "$d")
    done
    if [ "$vid" = "a69c" ]; then
        echo -e "${YELLOW}Encontrado /dev/$dev (VID=$vid PID=$pid). Fazendo eject...${NC}"
        if eject "/dev/$dev" 2>/dev/null; then
            echo -e "${GREEN}Eject OK em /dev/$dev${NC}"
        else
            # tenta por symlink aicudisk
            [ -e /dev/aicudisk ] && eject /dev/aicudisk 2>/dev/null && echo -e "${GREEN}Eject via aicudisk OK${NC}"
        fi
        found=1
    fi
done

# tambem tenta usb_modeswitch se disponivel (para clones Pandora 1111:1111)
if command -v usb_modeswitch >/dev/null 2>&1; then
    for d in /sys/bus/usb/devices/*; do
        [ -f "$d/idVendor" ] || continue
        v=$(cat "$d/idVendor" 2>/dev/null); p=$(cat "$d/idProduct" 2>/dev/null)
        if [ "$v" = "1111" ] && [ "$p" = "1111" ]; then
            prod=$(cat "$d/product" 2>/dev/null)
            echo "$prod" | grep -q "88M80" || continue
            bus=$(cat "$d/busnum"); devn=$(cat "$d/devnum")
            echo "Modo Pandora detectado. Executando usb_modeswitch..."
            usb_modeswitch -b "$bus" -g "$devn" -c /etc/usb_modeswitch.d/1111:1111 2>/dev/null || \
            usb_modeswitch -b "$bus" -g "$devn" -c "$(dirname $0)/../usb_modeswitch/1111_1111" 2>/dev/null
            found=1
        fi
    done
fi

if [ $found -eq 0 ]; then
    echo -e "${RED}Nenhum dispositivo AICSemi em modo pendrive encontrado.${NC}"
    echo "Talvez a placa ja esteja em modo WiFi, ou nao esteja conectada."
else
    echo ""
    echo "Aguarde alguns segundos e verifique com: lsusb | grep -i aic"
    echo "Se necessario, desconecte e reconecte a placa."
fi
