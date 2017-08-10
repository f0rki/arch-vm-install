echo "[+] configuring password ssh access for root"

sed -i 's/^PermitRootLogin.\+$/PermitRootLogin yes/' /etc/ssh/sshd_config
