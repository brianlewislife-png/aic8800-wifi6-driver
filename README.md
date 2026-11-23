# AIC8800 WiFi 6 USB Driver, Adaptador USB WiFi 6 Dual Band (2 Antenas)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Kernel](https://img.shields.io/badge/kernel-5.4--7.3-blue.svg)]()
[![Chipset](https://img.shields.io/badge/chipset-AIC8800D80-green.svg)]()
[![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)]()
[![Distro](https://img.shields.io/badge/distro-Debian%20%7C%20Ubuntu%20%7C%20Fedora%20%7C%20Arch-lightgrey.svg)]()

> **Driver Linux (DKMS) para adaptador USB WiFi 6 Dual Band com 2 Antenas**  
> Chipset **AICSemi AIC8800DC / AIC8800D80** (802.11ax, 2.4 GHz + 5 GHz).  
> Modo WiFi detectado: `a69c:88dc` (AIC8800DC). Modo pendrive: `a69c:5721`.  
> Resolve o problema clássico: a placa é reconhecida como **pendrive/CD-ROM USB** (modo Mass Storage, `a69c:5721`) em vez de placa de rede. As regras udev fazem o eject automático e a placa passa a funcionar como **WiFi USB**.

---

## 🔍 Palavras-chave (para busca)

adaptador usb wifi 6, driver wifi 6 linux, aic8800, aic8800d80, aicsemi, usb wifi dual band, placa wifi usb linux, pendrive reconhecido como wifi, modeswitch aic, debian wifi driver, ubuntu wifi driver, kernel 6.12 wifi, 802.11ax linux, wifi 6 usb adaptador 2 antenas, driver aic8800 debian 13, how to install aic8800 driver, aic8800 modeswitch 5721.

---

## ✨ Destaques

- ✅ Modo **pendrive → WiFi** automático via regras udev (sem intervenção manual)
- ✅ Instalador universal com **DKMS** (recompila após atualização de kernel)
- ✅ Suporta **Debian/Ubuntu, Fedora/RHEL, Arch, openSUSE, Alpine, Void, Solus**
- ✅ Kernels **5.4 a 7.3** (testado em Debian 13 / kernel `6.12.117+deb13-amd64`)
- ✅ Firmware e configuração `usb_modeswitch` inclusos
- ✅ Scripts de **diagnóstico** e **eject manual**
- ✅ Instalação em **um clique** no Debian/Ubuntu

---

## 📋 Índice

1. [Requisitos](#-requisitos)
2. [Instalação (Debian/Ubuntu um clique)](#-instalação-debianubuntu-um-clique)
3. [Instalação manual](#-instalação-manual)
4. [Instalação por distribuição](#-instalação-por-distribuição)
5. [Verificar se funcionou](#-verificar-se-funcionou)
6. [Se a placa continuar como pendrive](#-se-a-placa-continuar-como-pendrive)
7. [Diagnóstico](#-diagnóstico)
8. [Desinstalar](#-desinstalar)
9. [Estrutura do projeto](#-estrutura-do-projeto)
10. [Troubleshooting / FAQ](#-troubleshooting--faq)
11. [Créditos obrigatórios](#-créditos-obrigatórios)
12. [Licença](#-licença)

---

## 📦 Requisitos

- Linux com kernel **5.4 a 7.3**
- Compilador (`gcc`), `make`, headers do kernel
- Acesso root (`sudo`)
- Pacotes: `dkms`, `build-essential`, `linux-headers-$(uname -r)`, `mokutil`, `eject`, `usb-modeswitch`

## 🧩 Compatibilidade (versões que funcionam)

### Kernels testados

| Kernel | Status | Observação |
|--------|--------|------------|
| 5.4.x  | ✅ Suportado | LTS, funciona |
| 5.10.x | ✅ Suportado | LTS, funciona |
| 5.15.x | ✅ Suportado | LTS, funciona |
| 6.1.x  | ✅ Suportado | LTS Debian 12 |
| 6.6.x  | ✅ Suportado | LTS |
| 6.12.x | ✅ Testado  | Debian 13 (`6.12.117+deb13-amd64`), issue #110 do upstream |
| 6.16.x | ✅ Testado  | Ubuntu 25.04 |
| 7.0.x  | ⚠️ Experimental | Pode exigir `--force` |
| 7.1–7.3 | ⚠️ Experimental | Pode exigir `--force` |
| > 7.3  | ❌ Não suportado | Use `--force` por sua conta e risco |

### Distribuições testadas

| Distro | Versão | Kernel | Status |
|--------|--------|--------|--------|
| Debian | 12 (Bookworm) | 6.1.x | ✅ |
| Debian | 13 (Trixie) | 6.12.111 / 6.12.117 | ✅ Testado |
| Ubuntu | 22.04 / 24.04 | 5.15 / 6.8 | ✅ |
| Ubuntu | 25.04 | 6.16 | ✅ |
| Fedora | 40+ | 6.8+ | ✅ |
| Arch Linux | rolling | latest | ✅ |
| Linux Mint | 21/22 | 5.15/6.8 | ✅ |
| openSUSE | Tumbleweed | latest | ✅ |
| Alpine | 3.19+ | 6.6 | ⚠️ Parcial |
| Raspberry Pi OS | Bookworm | 6.6 | ⚠️ ARM, não totalmente testado |

### Arquiteturas

| Arquitetura | Status |
|-------------|--------|
| x86_64 (amd64) | ✅ Totalmente suportado |
| aarch64 (arm64) | ⚠️ Suportado, menos testado |
| armhf (32-bit) | ⚠️ Experimental |
| riscv64 | ⚠️ Experimental |

### Variantes de chip suportadas

| Variante | Firmware | Status |
|----------|----------|--------|
| AIC8800DC (esta placa) | `fw/aic8800DC/` | ✅ Principal (WiFi mode `a69c:88dc`) |
| AIC8800D80 | `fw/aic8800D80/` | ✅ Suportado (pendrive `a69c:5721`) |
| AIC8800D80N |, | Removido |
| AIC8800D80X2 |, | Removido |

### Modos USB

| VID:PID | Modo | Ação |
|---------|------|------|
| `a69c:5721` | Pendrive (MSC) | Eject automático → WiFi |
| `a69c:5722` | Pendrive (MSC) | Eject automático |
| `a69c:5723` | Pendrive (MSC) | Eject automático (Tenda) |
| `a69c:5724`–`5732` | Pendrive (MSC) | Eject automático (variantes) |
| `1111:1111` (produto 88M80) | Pandora clone | usb_modeswitch |

### Bluetooth (combo)

- Adapters combo usam o driver padrão `btusb` do kernel.
- O quirk `aic_zlp_quirk` é carregado automaticamente para `368b:8d81`.

### O que NÃO funciona

- ❌ Kernels < 5.4
- ❌ Kernels > 7.3 sem `--force`
- ❌ Secure Boot habilitado (módulo não carrega)
- ❌ Placas que não são AIC8800 (ex: Realtek, MediaTek), use o driver correspondente

---

## ⚡ Instalação (Debian/Ubuntu um clique)

```bash
git clone https://github.com/brianlewislife-png/aic8800-wifi6-driver.git
cd aic8800-wifi6-driver
sudo ./instalar_debian.sh
```

O script instala dependências, compila via DKMS, instala firmware, regras udev e carrega o módulo.

---

## 🛠️ Instalação manual

```bash
make                          # compila
sudo make install             # instala
sudo modprobe aic8800_fdrv    # carrega
```

---

## 🐧 Instalação por distribuição

### Debian / Ubuntu
```bash
sudo apt-get update
sudo apt-get install -y dkms build-essential linux-headers-$(uname -r) mokutil eject usb-modeswitch
sudo ./install.sh
```

### Fedora / RHEL / CentOS
```bash
sudo dnf install -y dkms make gcc mokutil util-linux usb_modeswitch kernel-devel kernel-headers
sudo ./install.sh
```

### Arch Linux
```bash
sudo pacman -S --needed dkms base-devel mokutil util-linux usb_modeswitch linux-headers
sudo ./install.sh
```

### openSUSE
```bash
sudo zypper install dkms make gcc mokutil util-linux usb_modeswitch kernel-devel
sudo ./install.sh
```

---

## 🔍 Verificar se funcionou

```bash
./scripts/diagnostico.sh
lsusb | grep -i aic
ip link show
iwconfig
nmcli device wifi list
sudo dmesg | grep aic8800
```

Saída esperada: a placa aparece em modo WiFi (não "Aic MSC"), e uma interface `wlan0`/`wlx...` surge.

---

## 🔁 Se a placa continuar como pendrive

```bash
sudo ./scripts/eject_placa.sh
# ou manualmente:
lsblk                       # identifique o disco (ex: /dev/sdb)
sudo eject /dev/sdX         # substitua X pela letra correta
```

Depois desconecte e reconecte a placa.

---

## 🩺 Diagnóstico

```bash
./scripts/diagnostico.sh
```

Mostra: modo da placa (pendrive/WiFi), módulos carregados, DKMS, firmware, regras udev, interfaces e logs.

---

## 🗑️ Desinstalar

```bash
sudo ./uninstall.sh
# ou manualmente:
sudo dkms remove aic8800/1.0.0 --all
sudo rm -rf /lib/firmware/aic8800*
sudo rm -f /usr/lib/udev/rules.d/aic.rules
```

---

## 📁 Estrutura do projeto

```
aic.rules                  # regras udev (modeswitch pendrive -> WiFi)
install.sh                 # instalador universal (DKMS)
instalar_debian.sh         # atalho Debian/Ubuntu (um clique)
uninstall.sh               # remocao
dkms.conf                 # configuracao DKMS
drivers/aic8800/          # codigo fonte do driver (aic8800_fdrv, aic_load_fw, aic_zlp_quirk)
fw/aic8800D80/            # firmware do chip
usb_modeswitch/           # config para clones Pandora
scripts/diagnostico.sh    # diagnostico
scripts/eject_placa.sh    # eject manual
README_PT.md              # documentacao em portugues
CREDITS.md                # creditos obrigatorios
LICENSE                   # MIT
```

---

## 🆘 Troubleshooting / FAQ

**P: A placa não aparece em `lsusb` como WiFi, só como "Aic MSC".**  
R: Rode `sudo ./scripts/eject_placa.sh` e reconecte. Verifique se `aic.rules` está em `/usr/lib/udev/rules.d/`.

**P: `modprobe aic8800_fdrv` falha.**  
R: Verifique `sudo dmesg | grep aic8800`. Pode ser Secure Boot (desative na BIOS) ou kernel headers ausentes.

**P: Erro de compilação no DKMS.**  
R: Confirme `linux-headers-$(uname -r)` instalado e gcc compatível. Veja `/var/log/aic8800-install.log`.

**P: Funciona em Raspberry Pi / ARM?**  
R: O driver suporta ARM via DKMS, mas precisa dos headers da plataforma. Testado principalmente em x86_64.

**P: A placa é WiFi+Bluetooth (combo).**  
R: O `aic_load_fw` inicializa o firmware; o Bluetooth usa o driver padrão `btusb` do kernel. O quirk `aic_zlp_quirk` é carregado automaticamente para `368b:8d81`.

**P: Kernel muito novo (> 7.3).**  
R: Use `sudo ./install.sh --force` por sua conta e risco.

---

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

---

## 📜 Licença

Código base (AIC8800) sob licença MIT do upstream (RicknotDev/shenmintao).  
Modificações, scripts, documentação e empacotamento: © Brian Lewis.

---

> Baseado em: https://github.com/RicknotDev/aic8800d80  
> Testado em: Debian 13, kernel 6.12.117+deb13-amd64 (issue #110 do upstream).
