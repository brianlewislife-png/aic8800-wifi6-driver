# AIC8800 WiFi 6 USB Driver

Driver Linux (DKMS) para adaptador USB WiFi 6 Dual Band (2 antenas) — chipset AIC8800D80/DC.

Resolve o problema: placa reconhecida como pendrive/CD-ROM USB (modo Mass Storage) em vez de placa de rede.

## Compatibilidade

- **Kernels:** 5.4 a 7.3 (testado em 6.12.117 Debian 13)
- **Distros:** Debian, Ubuntu, Fedora, RHEL, Arch, openSUSE, Alpine, Void, Solus
- **Arquitetura:** x86_64 (total), aarch64 (parcial), armhf/riscv64 (experimental)
- **USB:** 2.0 recomendado. USB 3.0 pode causar `bin upload fail` (err:-32)
- **VID:PID WiFi:** a69c:88dc | **VID:PID pendrive:** a69c:5721

## Instalação (Debian/Ubuntu um clique)

```bash
git clone https://github.com/brianlewislife-png/aic8800-wifi6-driver.git
cd aic8800-wifi6-driver
sudo ./instalar_debian.sh
```

## Instalação manual

```bash
sudo apt-get install -y dkms build-essential linux-headers-$(uname -r) mokutil eject usb-modeswitch
sudo ./install.sh
```

## Verificar

```bash
lsusb | grep -i aic
ip link show
nmcli device wifi list
```

## Se a placa continuar como pendrive

```bash
sudo ./scripts/eject_placa.sh
```

## Se o probe falhar (error -1)

```bash
sudo ./scripts/fix_probe.sh
```

## Desinstalar

```bash
sudo ./uninstall.sh
```

## Estrutura

```
aic.rules              # regras udev
install.sh             # instalador universal (DKMS)
instalar_debian.sh     # atalho Debian/Ubuntu
uninstall.sh           # remoção
dkms.conf             # config DKMS
drivers/aic8800/       # código fonte
fw/aic8800D80/         # firmware D80
fw/aic8800DC/          # firmware DC
usb_modeswitch/        # config Pandora
scripts/               # diagnostico, eject, fix_probe, pandora_modeswitch
CREDITS.md             # créditos obrigatórios
LICENSE                # MIT
```

## Placas compatíveis

Tenda U11, Mercusys AX300/AX900, UGREEN AX900/AX900BT, Brostrend AX900BT, Cudy WU1300S, EDUP EP-AC1621, adaptadores genéricos AX300/AX900.

Verifique: `lsusb | grep -i aic` (deve mostrar a69c:88dc ou a69c:5721)

## Créditos obrigatórios (não remover)

- Autor: Brian Lewis
- GitHub: github.com/brianlewislife-png
- LinkedIn: linkedin.com/in/brian-lewis-4ba63739a
- Telegram: t.me/brianlewisdev
- Instagram: instagram.com/Brian_lewis_2
- YouTube: youtube.com/@brianlewisdeveloper
- Canal Zap: https://www.whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45

Veja CREDITS.md. Remover créditos é proibido.

## Licença

MIT (veja LICENSE). Código base: RicknotDev/shenmintao (MIT). Modificações: © Brian Lewis.