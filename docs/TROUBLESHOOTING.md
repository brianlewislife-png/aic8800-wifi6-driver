# Troubleshooting (Solução de Problemas)

## A placa não é reconhecida como WiFi

1. Rode `sudo ./scripts/eject_placa.sh`.
2. Reconecte a placa.
3. Verifique `lsusb | grep -i aic`.

## Erro: "module not found" / "modprobe aic8800_fdrv" falha

- Verifique se o DKMS compilou: `dkms status | grep aic8800`.
- Veja o log: `cat /var/log/aic8800-install.log`.
- Confirme headers: `ls /lib/modules/$(uname -r)/build`.

## Erro: "Operation not permitted" ao carregar módulo

- Secure Boot ativo. Desative na BIOS/UEFI.
- Ou assine o módulo (avançado).

## WiFi não conecta / sem redes

- `nmcli device wifi list`
- `sudo dmesg | grep aic8800`
- Verifique firmware: `ls /lib/firmware/aic8800D80/`.

## Kernel atualizado e WiFi parou

- O DKMS deve recompilar automaticamente. Se não, rode `sudo dkms autoinstall`.

## Bluetooth não funciona (combo)

- Verifique `bluetoothctl list`.
- O driver padrão `btusb` deve assumir. Veja `dmesg | grep -i btusb`.

## Mais ajuda

Abra uma issue em: https://github.com/brianlewislife-png/aic8800-wifi6-driver/issues
Inclua a saída de `./scripts/diagnostico.sh`.
