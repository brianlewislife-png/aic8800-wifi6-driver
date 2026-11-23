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

**Versões USB afetadas:** USB 3.0, 3.1, 3.2 (portas azuis)

**Causas:**
- Instabilidade na transferência de firmware via USB 3.0
- Firmware incompatível com a revisão do chip
- Porta USB instável
- Cabo USB com problema

**Soluções (tente nesta ordem):**
1. **Use porta USB 2.0** (pretas, não azuis):
   ```bash
   # Verifique a versão da porta
   lsusb -t
   # 480M = USB 2.0 (recomendado)
   # 5000M = USB 3.0 (pode causar problemas)
   ```

2. **Use hub USB 2.0** se só tiver portas USB 3.0:
   - Conecte um hub USB 2.0 entre a placa e o PC

3. **Desative USB autosuspend:**
   ```bash
   echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend
   echo "options usbcore autosuspend=-1" | sudo tee /etc/modprobe.d/usb-autosuspend.conf
   ```

4. **Tente outras variantes de firmware:**
   ```bash
   # h_u02
   sudo cp /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc_h_u02.bin /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc.bin
   sudo ./scripts/fix_probe.sh

   # ipc_u02
   sudo cp /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc_ipc_u02.bin /usr/lib/firmware/aic8800DC/fmacfw_patch_8800dc.bin
   sudo ./scripts/fix_probe.sh
   ```

5. **Use cabo USB curto** (< 1m) e de qualidade

6. **Se nada funcionar:** a revisão do chip pode não ser suportada pelo driver open-source

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
