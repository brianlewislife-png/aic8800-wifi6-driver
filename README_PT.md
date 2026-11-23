# Driver AIC8800 WiFi 6 - Adaptador USB Dual Band (2 Antenas)

Pacote de driver para a placa **Adaptador USB WiFi 6 Dual Band com 2 Antenas**,
baseada no chipset **AICSemi AIC8800D80** (WiFi 6, 802.11ax, dual band 2.4/5 GHz).

Este pacote resolve o problema clássico desta placa: ela é reconhecida pelo
Linux como um **pendrive/CD-ROM USB** (modo "Mass Storage", VID `a69c`,
PID `5721`) em vez de placa de rede. A regra udev incluída faz o "eject"
automático do disco virtual, trocando o dispositivo para o modo WiFi, onde o
driver `aic8800_fdrv` assume o controle.

## Seu dispositivo (detectado neste sistema)

- VID/PID em modo pendrive: `a69c:5721` (Aic MSC)
- Interface: Mass Storage (classe 08/06/50)
- Chip: AIC8800D80

## O que este pacote instala

1. **Regras udev** (`/usr/lib/udev/rules.d/aic.rules`) - detectam a placa em
   modo pendrive e executam `eject`, trocando para modo WiFi.
2. **Driver kernel** (DKMS): `aic8800_fdrv` + `aic_load_fw` + `aic_zlp_quirk`.
3. **Firmware** em `/lib/firmware/aic8800D80/` (e variantes).
4. **Config usb_modeswitch** para clones "Pandora".
5. **DKMS** para recompilar automaticamente após atualizações de kernel.

## Requisitos

- Linux com kernel 5.4 a 7.3 (testado em Debian 13 / kernel 6.12.117)
- Compilador (gcc), make, headers do kernel
- Acesso root (sudo)

## Instalação (Debian/Ubuntu um clique)

```bash
cd "aic8800-wifi6-driver"
sudo apt-get update
sudo apt-get install -y dkms build-essential linux-headers-$(uname -r) \
    mokutil eject usb-modeswitch
sudo ./install.sh
```

O script detecta automaticamente a distribuição, instala dependências, compila,
instala firmware, regras udev e carrega o módulo.

## Instalação manual (se preferir)

```bash
make                          # compila
sudo make install             # instala
sudo modprobe aic8800_fdrv    # carrega
```

## Verificar se funcionou

```bash
lsusb | grep -i aic           # deve mostrar a placa em modo WiFi (não MSC)
ip link show                  # deve aparecer wlan0/wlx...
iwconfig                      # interface wireless
sudo dmesg | grep aic8800     # logs do driver
nmcli device wifi list        # redes disponíveis
```

## Se a placa continuar como pendrive

Execute manualmente o eject:

```bash
lsblk                         # identifique o disco (ex: /dev/sdb)
sudo eject /dev/sdX           # substitua X pela letra correta
# ou use o script:
sudo ./scripts/eject_placa.sh
```

Ou desconecte e reconecte a placa após a instalação das regras udev.

## Diagnóstico

```bash
./scripts/diagnostico.sh
```

## Desinstalar

```bash
sudo dkms remove aic8800/1.0.0 --all
sudo rm -rf /lib/firmware/aic8800*
sudo rm /usr/lib/udev/rules.d/aic.rules
```

## Arquivos importantes

- `aic.rules` - regras udev (modeswitch pendrive -> WiFi)
- `install.sh` - instalador universal (DKMS)
- `usb_modeswitch/` - config para clones Pandora
- `fw/aic8800D80/` - firmware do chip
- `drivers/aic8800/` - código fonte do driver

## Suporte

Baseado em: https://github.com/RicknotDev/aic8800d80
Testado em: Debian 13, kernel 6.12.117 (issue #110 do upstream).

## Licença

MIT (veja LICENSE).

## CREDITOS OBRIGATORIOS (nao remover)

Este pacote so pode ser redistribuido mantendo integralmente os creditos:

- Autor: Brian Lewis
- GitHub: github.com/brianlewislife-png
- LinkedIn: linkedin.com/in/brian-lewis-4ba63739a
- Telegram: t.me/brianlewisdev
- Instagram: instagram.com/Brian_lewis_2
- Canal Zap: https://www.whatsapp.com/channel/0029Vb8ZCiC3QxRsbIylpN45
- X / Twitter e Reddit: links oficiais em breve

Veja o arquivo `CREDITS.md`. Remover ou alterar estes creditos e proibido.
