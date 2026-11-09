# Dropaholic

Sistema baseado em **Debian 13 (trixie)**, feito para dar nova vida ao
**Samsung RF411** (Core i5/i7 2ª geração, Intel HD 3000 + GeForce GT 540M,
~4 GB de RAM).

## Como gerar a ISO

Em Debian/Ubuntu (ou VM/container deles) com internet e ~20 GB livres:

    chmod +x build.sh
    ./build.sh

A ISO sai em `out/`. Grave no pendrive com `dd` ou Ventoy e dê boot no RF411.
Na sessão Live o usuário é `user` e a senha é `live` (padrão do live-config).

## O que vem instalado

- **Desktop:** XFCE leve, sem compositor, tema preto `#0b0b10` e roxo `#8b5cf6`.
- **Apps:** Steam, Visual Studio Code, Brave, Discord, LibreOffice
  (Writer, Calc, Impress, Draw, em pt-BR), Firefox ESR.
- **Dev:** git, neovim, python, node, docker, build-essential.
- **Vídeo:** Mesa + nouveau. Intel HD 3000 é a GPU padrão; para rodar algo na
  GT 540M use `dgpu <comando>` (equivale a `DRI_PRIME=1`).
- **Rede:** NetworkManager, wpasupplicant e firmwares de Atheros, Realtek,
  Broadcom (brcm80211), Intel e Ralink.
- **Desempenho:** zram (zstd), earlyoom, sysctl, tlp e thermald.
- **Instalador:** Calamares com branding do Dropaholic.

## Como os apps externos entram

Brave, VS Code e Discord não estão no Debian. O hook
`config/hooks/live/0200-extra-apps.hook.chroot` adiciona os repositórios
oficiais (Brave e Microsoft) e baixa o .deb do Discord durante o build, e
também habilita a arquitetura i386 para a Steam. Por isso o build precisa de
internet. O Discord vem de um .deb fixo, então ele pode pedir atualização na
primeira abertura.

## Limitações (importante)

- Intel HD 3000 e GT 540M **não têm Vulkan** no driver livre: DXVK/Proton
  moderno não funciona. Jogos nativos OpenGL, emuladores e jogos leves vão
  bem; jogos modernos pesados, não.
- Driver proprietário NVIDIA 390xx **não foi incluído**: não consegui confirmar
  que ele existe no Debian 13 e costuma quebrar com kernels novos.
- Wifi Broadcom antigo (chips BCM43xx mais velhos) pode exigir
  `broadcom-sta-dkms` pós-instalação.
- **4 GB de RAM:** VS Code, Brave, Discord e Steam abertos juntos vão pesar.
  O zram ajuda, mas use um ou dois por vez.
- O sistema fica maior (~20 GB livres para o build, ISO bem maior que antes).

## Estado do projeto

Primeira versão, **ainda não testada em ISO real**. Os comandos de repositório
do Brave e do VS Code vêm das páginas oficiais; a URL de download do Discord
e os nomes de pacotes do Debian não foram testados aqui. Se o build falhar,
o erro costuma apontar o pacote ou a linha do hook.

## Próximos passos

1. Buildar e testar em VM antes do RF411.
2. Testar a instalação pelo Calamares em BIOS e UEFI.
3. Lutris/Heroic, logo e wallpaper definitivos.

## Gerar a ISO pelo GitHub (sem precisar de Linux)

1. Crie um repositório **público** no GitHub (em repositório privado o
   artefato da ISO não cabe na cota gratuita).
2. Envie este projeto (a pasta `.github` precisa ir junto):

       git init && git add . && git commit -m "Dropaholic"
       git branch -M main
       git remote add origin https://github.com/SEU_USUARIO/dropaholic.git
       git push -u origin main

3. No GitHub: aba **Actions** > **Build Dropaholic ISO** > **Run workflow**.
4. Aguarde (30 a 90 min). Ao terminar, baixe o artefato `dropaholic-iso`
   (ele guarda a ISO e o SHA256SUMS por 7 dias).
5. Se falhar, baixe o artefato `build-logs` ou copie o erro do log e envie.
