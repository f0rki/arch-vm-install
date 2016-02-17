#!/usr/bin/env bash
set -eux -o pipefail

source config.sh

echo "[+] clearing partition table on ${DISK}"
/usr/bin/sgdisk --zap ${DISK}

echo "[+] destroying magic strings and signatures on ${DISK}"
/usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
/usr/bin/wipefs --all ${DISK}

echo "[+] creating /root partition on ${DISK}"
/usr/bin/sgdisk --new=1:0:0 ${DISK}

echo "[+] setting ${DISK} bootable"
/usr/bin/sgdisk ${DISK} --attributes=1:set:2

echo '[+] creating /root filesystem (ext4)'
/usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}

echo "[+] mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

echo '[+] bootstrapping the base installation'
/usr/bin/pacstrap ${TARGET_DIR} base base-devel
/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm gptfdisk openssh syslinux
/usr/bin/arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
# ensure syslinux is installed on the correct disk
/usr/bin/sed -i "s/sda3/sda1/" "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
/usr/bin/sed -i "s/sda/$(basename $DISK)/" "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
/usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"

echo '[+] generating the filesystem table'
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

if [[ -f ./mirrorlist ]]; then
    echo '[+] setting mirrors'
    cp ./mirrorlist "${TARGET_DIR}/etc/pacman.d/mirrorlist"
fi

CONFIG_SCRIPT_PATH="${TARGET_DIR}/${CONFIG_SCRIPT}"
echo "[+] generating the system configuration script '$CONFIG_SCRIPT_PATH'"
/usr/bin/install --mode=0755 /dev/null "$CONFIG_SCRIPT_PATH"
echo "#!/bin/bash" >> "$CONFIG_SCRIPT_PATH"
echo "set -eu -o pipefail" >> "$CONFIG_SCRIPT_PATH"
echo "" >> "$CONFIG_SCRIPT_PATH"
# copy configuration to script
cat config.sh >> "$CONFIG_SCRIPT_PATH"
echo "" >> "$CONFIG_SCRIPT_PATH"

# basic setup from within
cat setup.sh >> "$CONFIG_SCRIPT_PATH"
echo "" >> "$CONFIG_SCRIPT_PATH"

if [[ "$VAGRANT" == "yes" ]]; then
    echo "[+] setting up for vagrant use"
    cat vagrant.sh >> "$CONFIG_SCRIPT_PATH"
fi
if [[ "$VIRTUALBOX" == "yes" ]]; then
    echo "[+] setting up for virtualbox use"
    cat vbox.sh >> "$CONFIG_SCRIPT_PATH"
fi
if [[ "$ROOT_TTY_AUTOLOGIN" == "yes" ]]; then
    echo "[+] setting up autologin for root on tty1"
    cat root-auto-tty.sh >> "$CONFIG_SCRIPT_PATH"
fi
if [[ "$ROOT_ALLOW_SSH" == "yes" ]]; then
    echo "[+] setting up autologin for root on tty1"
    cat root-ssh.sh >> "$CONFIG_SCRIPT_PATH"
fi

echo '[+] entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}

# clean up
/usr/bin/arch-chroot ${TARGET_DIR} /usr/bin/pacman -Rcns --noconfirm gptfdisk
/usr/bin/arch-chroot ${TARGET_DIR} /usr/bin/pacman -Scc --noconfirm
rm "${TARGET_DIR}${CONFIG_SCRIPT}"


# http://comments.gmane.org/gmane.linux.arch.general/48739
echo '[+] adding workaround for shutdown race condition'
/usr/bin/install --mode=0644 poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo '[+] installation complete!'
/usr/bin/sync
/usr/bin/sleep 3
/usr/bin/umount ${TARGET_DIR}
/usr/bin/systemctl reboot
