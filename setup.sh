#### setup the system from within the arch chroot

echo "${FQDN}" > /etc/hostname
/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf
/usr/bin/sed -i "s/#${LANGUAGE}/${LANGUAGE}/" /etc/locale.gen
/usr/bin/locale-gen
/usr/bin/mkinitcpio -p linux
printf "$PASSWORD\n$PASSWORD\n" | passwd root
# https://wiki.archlinux.org/index.php/Network_Configuration#Device_names
/usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
/usr/bin/ln -s '/usr/lib/systemd/system/dhcpcd@.service' '/etc/systemd/system/multi-user.target.wants/dhcpcd@eth0.service'
/usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
/usr/bin/systemctl enable sshd.service

/usr/bin/dirmngr < /dev/null
/usr/bin/pacman-keys --refresh-keys
/usr/bin/pacman -Syu --noconfirm
/usr/bin/pacman-db-upgrade
/usr/bin/pacman -Syu --noconfirm
