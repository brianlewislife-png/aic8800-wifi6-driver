# Guia de Instalação Detalhado

## Identificar sua placa

Conecte a placa e rode:

```bash
lsusb | grep -i aic
```

Se aparecer `a69c:5721` com "Aic MSC", ela está em modo pendrive (normal na primeira vez).

## Passo a passo (Debian 13 / Ubuntu 24.04)

1. Instale dependências:
   ```bash
   sudo apt-get update
   sudo apt-get install -y dkms build-essential linux-headers-$(uname -r) mokutil eject usb-modeswitch
   ```

2. Clone e instale:
   ```bash
   git clone https://github.com/brianlewislife-png/aic8800-wifi6-driver.git
   cd aic8800-wifi6-driver
   sudo ./install.sh
   ```

3. Verifique:
   ```bash
   lsusb | grep -i aic        # deve mostrar modo WiFi, não MSC
   ip link show               # deve aparecer wlan0/wlx...
   ```

## Instalação offline

Baixe o zip do repositório e extraia. Rode `sudo ./install.sh --skip-deps` após instalar as dependências manualmente.

## Secure Boot

Se o módulo não carregar, desative o Secure Boot na BIOS/UEFI. O instalador detecta e avisa.

## Links úteis

- Repositório: https://github.com/brianlewislife-png/aic8800-wifi6-driver
- Créditos: CREDITS.md
- Changelog: CHANGELOG.md
