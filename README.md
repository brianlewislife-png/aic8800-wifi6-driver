# AIC8800 WiFi 6 USB Driver (Dual Band, 2 Antenas)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Kernel](https://img.shields.io/badge/kernel-5.4--7.3-blue.svg)]()
[![Chipset](https://img.shields.io/badge/chipset-AIC8800D80-green.svg)]()

Driver Linux (DKMS) para o adaptador **USB WiFi 6 Dual Band com 2 Antenas**,
baseado no chipset **AICSemi AIC8800D80** (802.11ax, 2.4/5 GHz).

Resolve o problema clássico desta placa: ela é reconhecida pelo Linux como
**pendrive/CD-ROM USB** (modo Mass Storage, `a69c:5721`) em vez de placa de
rede. As regras udev incluídas fazem o eject automático, trocando o
dispositivo para o modo WiFi, onde o driver `aic8800_fdrv` assume o controle.

## ✨ Destaques

- Modo pendrive → WiFi automático (udev)
- Instalador universal (DKMS) com detecção de distro
- Suporte a Debian/Ubuntu, Fedora, RHEL, Arch, openSUSE, Alpine, Void, Solus
- Kernels 5.4 a 7.3 (testado em Debian 13 / 6.12.117)
- Firmware e regras usb_modeswitch inclusos
- Scripts de diagnóstico e eject manual

## 📦 Instalação (Debian/Ubuntu — um clique)

```bash
git clone https://github.com/brianlewislife-png/aic8800-wifi6-driver.git
cd aic8800-wifi6-driver
sudo ./instalar_debian.sh
```

Ou manualmente:

```bash
sudo apt-get install -y dkms build-essential linux-headers-$(uname -r) \
    mokutil eject usb-modeswitch
sudo ./install.sh
```

## 🔍 Verificar

```bash
./scripts/diagnostico.sh
lsusb | grep -i aic
ip link show
nmcli device wifi list
```

Se a placa continuar como pendrive:

```bash
sudo ./scripts/eject_placa.sh
```

## 🗑️ Desinstalar

```bash
sudo ./uninstall.sh
```

## 📁 Estrutura

```
aic.rules            # regras udev (modeswitch pendrive -> WiFi)
install.sh           # instalador universal (DKMS)
instalar_debian.sh   # atalho Debian/Ubuntu
uninstall.sh         # remocao
dkms.conf            # configuracao DKMS
drivers/aic8800/     # codigo fonte do driver
fw/aic8800D80/       # firmware do chip
usb_modeswitch/      # config para clones Pandora
scripts/             # diagnostico e eject manual
CREDITS.md           # creditos obrigatorios
```

## 🧾 Créditos OBRIGATÓRIOS (não remover)

Este pacote só pode ser redistribuído mantendo integralmente os créditos:

- **Autor:** Brian Lewis
- **GitHub:** https://github.com/brianlewislife-png
- **LinkedIn:** https://www.linkedin.com/in/brian-lewis-4ba63739a
- **Telegram:** https://t.me/brianlewisdev
- **Instagram:** https://www.instagram.com/Brian_lewis_2
- **Canal Zap:** https://www.whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
- **X / Twitter e Reddit:** links oficiais em breve

Veja `CREDITS.md`. Remover ou alterar estes créditos é proibido.

## 📜 Licença

Código base (AIC8800) sob licença MIT do upstream (RicknotDev/shenmintao).
Modificações, scripts, documentação e empacotamento: © Brian Lewis.

---

> Baseado em: https://github.com/RicknotDev/aic8800d80
