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
# diagnostico.sh - Diagnostico da placa AIC8800 WiFi 6 USB
# Detecta se a placa esta em modo pendrive (MSC) ou WiFi e mostra status do driver.

set -u

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}=== Diagnostico AIC8800 WiFi 6 USB ===${NC}"
echo "Kernel: $(uname -r)"
echo "Data: $(date)"
echo ""

echo -e "${BLUE}[1] Dispositivos USB AICSemi (VID a69c):${NC}"
found=0
for d in /sys/bus/usb/devices/*; do
    [ -f "$d/idVendor" ] || continue
    v=$(cat "$d/idVendor" 2>/dev/null)
    [ "$v" = "a69c" ] || continue
    p=$(cat "$d/idProduct" 2>/dev/null)
    man=$(cat "$d/manufacturer" 2>/dev/null | tr -d '\0')
    prod=$(cat "$d/product" 2>/dev/null | tr -d '\0')
    cls=$(cat "$d/bDeviceClass" 2>/dev/null)
    ifc=$(cat "$d"/*:1.0/bInterfaceClass 2>/dev/null)
    speed=$(cat "$d/speed" 2>/dev/null)
    echo "  $d -> VID=$v PID=$p [$man] [$prod] class=$cls ifc=$ifc speed=$speed"
    found=1
    # detecta modo
    if [ "$ifc" = "08" ]; then
        echo -e "    ${YELLOW}-> MODO PENDRIVE/CD-ROM (Mass Storage). Precisa eject/modeswitch.${NC}"
    elif [ "$ifc" = "ff" ] || [ "$ifc" = "e0" ]; then
        echo -e "    ${GREEN}-> MODO WiFi (vendor-specific). Driver deve assumir.${NC}"
    else
        echo "    -> Interface class $ifc"
    fi
done
[ $found -eq 0 ] && echo -e "  ${RED}Nenhuma placa AICSemi detectada.${NC} Conecte a placa."

echo ""
echo -e "${BLUE}[2] Todos os USB (resumo):${NC}"
for d in /sys/bus/usb/devices/*; do
    [ -f "$d/idVendor" ] || continue
    v=$(cat "$d/idVendor" 2>/dev/null); p=$(cat "$d/idProduct" 2>/dev/null)
    prod=$(cat "$d/product" 2>/dev/null | tr -d '\0')
    [ -n "$prod" ] && echo "  $v:$p  $prod"
done | sort -u

echo ""
echo -e "${BLUE}[3] Modulos do driver:${NC}"
for m in aic8800_fdrv aic_load_fw aic_zlp_quirk; do
    if lsmod | grep -q "^$m "; then
        echo -e "  ${GREEN}$m : CARREGADO${NC}"
    else
        echo -e "  ${YELLOW}$m : nao carregado${NC}"
    fi
done

echo ""
echo -e "${BLUE}[4] DKMS:${NC}"
if command -v dkms >/dev/null 2>&1; then
    dkms status 2>/dev/null | grep -i aic || echo "  (nenhum registro aic8800 no DKMS)"
else
    echo "  dkms nao instalado"
fi

echo ""
echo -e "${BLUE}[5] Firmware:${NC}"
ls -d /lib/firmware/aic8800* 2>/dev/null || echo "  (nenhum firmware aic8800 em /lib/firmware)"

echo ""
echo -e "${BLUE}[6] Regras udev:${NC}"
ls -l /usr/lib/udev/rules.d/aic.rules /etc/udev/rules.d/aic.rules 2>/dev/null || echo "  aic.rules NAO instalado"

echo ""
echo -e "${BLUE}[7] Interfaces de rede wireless:${NC}"
if command -v iw >/dev/null 2>&1; then
    iw dev 2>/dev/null || echo "  (nenhuma)"
fi
ip -br link show 2>/dev/null | grep -iE "wl|wlan" || echo "  (nenhuma interface wlan detectada)"

echo ""
echo -e "${BLUE}[8] Logs recentes do driver:${NC}"
dmesg 2>/dev/null | grep -iE "aic8800|aic_load|aicudisk" | tail -20 || echo "  (sem logs)"

echo ""
echo -e "${CYAN}=== Fim do diagnostico ===${NC}"
echo "Se a placa aparecer em modo pendrive, rode: sudo ./scripts/eject_placa.sh"
