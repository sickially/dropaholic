#!/usr/bin/env bash
# Dropaholic (base Debian 13 "trixie") - gera a ISO com live-build.
# Rode em Debian/Ubuntu (ou numa VM/container deles), com internet e ~15 GB livres.
# Uso: ./build.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
BUILD="$HERE/build"
OUT="$HERE/out"

echo "==> Dependencias"
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools

rm -rf "$BUILD"; mkdir -p "$BUILD" "$OUT"
cp -r "$HERE/config" "$BUILD/config"
chmod +x "$BUILD"/config/hooks/live/*.hook.chroot
cd "$BUILD"

echo "==> Configurando live-build"
lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --bootloaders "syslinux,grub-efi" \
  --debian-installer none \
  --archive-areas "main contrib non-free non-free-firmware" \
  --linux-flavours amd64 \
  --iso-volume "DROPAHOLIC" \
  --iso-application "Dropaholic" \
  --iso-publisher "Dropaholic" \
  --memtest none \
  --bootappend-live "boot=live components quiet splash"

echo "==> Gerando ISO (demora bastante)"
sudo lb build 2>&1 | tee "$BUILD/build.log"

ISO="$(ls -1 "$BUILD"/*.iso | head -n1)"
cp "$ISO" "$OUT/dropaholic-$(date +%Y%m%d).iso"
echo "Pronto: $OUT/dropaholic-$(date +%Y%m%d).iso"
