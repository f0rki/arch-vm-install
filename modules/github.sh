###############################################################################

/usr/bin/pacman -Syu --noconfirm curl jq

if /usr/bin/curl -L "http://api.github.com/users/$GITHUB_USER_SSHKEYS/keys" \
    | /usr/bin/jq -r '.[].key' \
    >> /root/.ssh/authorized_keys
then
    echo "added keys from github user $GITHUB_USER_SSHKEYS"
else
    echo "WARNING: failed to fetch ssh public keys from GH"
fi

###############################################################################
