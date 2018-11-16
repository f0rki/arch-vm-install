###############################################################################

pushd /etc/pacman.d

pacman -Syu --noconfirm --needed pacman-contrib

cp mirrorlist mirrorlist.bak
curl \
    "https://www.archlinux.org/mirrorlist/?country=$MIRROR_COUNTRY&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on"\
    > mirrorlist.$MIRROR_COUNTRY
sed -i 's/^#Server/Server/' mirrorlist.$MIRROR_COUNTRY
rankmirrors -n 10 mirrorlist.$MIRROR_COUNTRY > mirrorlist

popd

###############################################################################
