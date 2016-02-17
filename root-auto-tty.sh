echo "[+] configuring autologin of root at tty1"

# https://wiki.archlinux.org/index.php/Automatic_login_to_virtual_console

mkdir -p /etc/systemd/system/getty@tty1.service.d/

cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin username --noclear %I $TERM
EOF
