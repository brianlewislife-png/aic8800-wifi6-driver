# Como publicar este repositorio no GitHub (profissional)

## 1. Criar o repositorio no GitHub

1. Acesse https://github.com/new
2. Nome sugerido: `aic8800-wifi6-driver`
3. Descricao: `Driver Linux (DKMS) para adaptador USB WiFi 6 Dual Band (2 antenas) - chipset AIC8800D80. Resolve modo pendrive -> WiFi.`
4. Publico (para aparecer em buscas)
5. NAO inicialize com README (ja temos)
6. Criar repositorio

## 2. Conectar e enviar (no terminal)

```bash
cd "/home/sombra/dual usb wifi 6/aic8800-wifi6-driver"
git remote add origin https://github.com/brianlewislife-png/aic8800-wifi6-driver.git
git push -u origin main
```

Se pedir autenticacao, use um Personal Access Token (PAT) com escopo `repo`.

## 3. Deixar pesquisavel (Settings do repo)

- About -> Topics: `aic8800`, `wifi6`, `linux-driver`, `usb-wifi`, `dkms`, `debian`, `aicsemi`, `802.11ax`, `dual-band`
- About -> Website: link do seu canal/contato
- Ative "Releases" e crie uma release v1.0.0 com o zip do pacote

## 4. Dicas para aparecer em buscas

- Mantenha o README.md com palavras-chave: "aic8800", "wifi 6", "usb", "linux", "driver", "debian", "pendrive"
- Adicione uma imagem/screenshot na pasta `docs/` (opcional) e referencie no README
- Crie uma release com tag `v1.0.0`

## Creditos

Mantenha os creditos de Brian Lewis intactos em todos os arquivos (CREDITS.md).
