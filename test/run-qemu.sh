#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function make_cloudinit() {
	mkisofs -iso-level 4 -o cloudinit.iso ${SCRIPT_DIR}/cloudinit/
}

function run() {
	dd if=/dev/zero of=disk.img bs=1M count=1024
		
	export SDL_VIDEO_X11_DGAMOUSE=0
	
	sudo qemu-system-x86_64 \
	-enable-kvm \
	-machine type=q35 \
	-smp 1 \
	-m 2048 \
	-machine q35,accel=kvm:hax:tcg \
	-bios /usr/share/qemu/OVMF.fd \
	-drive file=dind-efi.iso,index=1,media=cdrom \
	-drive file=cloudinit.iso,index=2,media=cdrom \
	-boot d \
	-object rng-builtin,id=rng0 \
	-device virtio-rng,rng=rng0 \
	-device e1000,netdev=net0 \
	-netdev tap,id=net0,script=/etc/qemu-ifup-br \
	-hda disk.img \
	-nographic
}

(cd build && make_cloudinit && run)

