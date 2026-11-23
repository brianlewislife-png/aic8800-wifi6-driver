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

## Erro: "probe with driver aic8800_fdrv failed with error -1"

Este é o erro mais comum. Causas e soluções:

### 1. Firmware não encontrado (mais comum)
**Sintoma no dmesg:** `rwnx_load_firmware: fmacfw_patch_8800dc.bin file failed to open` ou `No such file or directory`

**Solução:**
```bash
sudo mkdir -p /usr/lib/firmware
sudo cp -r /caminho/do/pacote/fw/aic8800DC /usr/lib/firmware/
sudo cp /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc_u02.bin /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc.bin
sudo ./scripts/fix_probe.sh
```

### 2. Caminho de firmware errado
**Sintoma:** aic_fw_path vazio ou apontando para lugar errado.

**Solução:**
```bash
sudo modprobe -r aic8800_fdrv aic_load_fw
sudo modprobe aic_load_fw aic_fw_path=/usr/lib/firmware
sudo modprobe aic8800_fdrv
```

### 3. "bin upload fail: 180000, err:-32" (USB broken pipe)
**Sintoma no dmesg:** `bin upload fail: 180000, err:-32`

**Causas possíveis:**
- Firmware incompatível com a revisão do chip (chip_sub_id).
- Porta USB instável (tente outra porta, preferencialmente USB 2.0).
- Cabo USB com problema.

**Soluções:**
1. Tente outras variantes de firmware:
```bash
# Tentar com h_u02
sudo cp /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc_h_u02.bin /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc.bin
sudo ./scripts/fix_probe.sh

# Tentar com ipc_u02
sudo cp /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc_ipc_u02.bin /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc.bin
sudo ./scripts/fix_probe.sh
```

2. Tente em outra porta USB (USB 2.0 preferencialmente).
3. Teste com outro cabo USB.

### 4. Módulo não encontrado
**Sintoma:** `modprobe: FATAL: Module aic8800_fdrv not found`

**Solução:**
```bash
sudo /usr/sbin/dkms build -m aic8800 -v 1.0.0 --force
sudo /usr/sbin/dkms install -m aic8800 -v 1.0.0 --force
sudo depmod -a
```

### 5. Secure Boot
**Sintoma:** módulo não carrega, dmesg mostra "Required key not available"

**Solução:** Desative o Secure Boot na BIOS/UEFI.

### 6. Sem interface WiFi após probe OK
**Sintoma:** probe OK mas nenhuma interface wlan aparece.

**Solução:**
```bash
sudo ip link set wlan0 up 2>/dev/null
sudo systemctl restart NetworkManager
nmcli device status
```

### Diagnóstico completo
```bash
./scripts/diagnostico.sh
sudo dmesg | grep -iE "aic8800|fmacfw|bin upload|probe" | tail -20
```

## Mais ajuda

Abra uma issue em: https://github.com/brianlewislife-png/aic8800-wifi6-driver/issues
Inclua a saída de `./scripts/diagnostico.sh` e `sudo dmesg | grep -i aic8800`.
