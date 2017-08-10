###############################################################################

echo '[+] setting up $CREATE_USER-specific configuration'
/usr/bin/groupadd users
/usr/bin/useradd --password ${PASSWORD} \
    --comment '$CREATE_USER User' \
    --create-home --gid users --groups users $CREATE_USER
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/20_user
echo "$CREATE_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/20_user
/usr/bin/chmod 0440 /etc/sudoers.d/20_user
/usr/bin/install --directory --owner=$CREATE_USER --group=users --mode=0700 /home/$CREATE_USER/.ssh
if [[ -f /root/.ssh/authorized_keys ]]; then
    /usr/bin/cp /root/.ssh/authorized_keys /home/$CREATE_USER/.ssh/authorized_keys 
fi
/usr/bin/chown $CREATE_USER:users /home/$CREATE_USER/.ssh/authorized_keys
/usr/bin/chmod 0600 /home/$CREATE_USER/.ssh/authorized_keys

###############################################################################
