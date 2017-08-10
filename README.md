# Usage

1. Boot archlinux live ISO in VM
2. Download install scripts **inside VM**
    ```
    wget https://github.com/f0rki/arch-vm-install/archive/master.tar.gz
    tar xf master.tar.gz
    ```
4. Edit the configuration, setting default password etc.
    ```
    $EDITOR config.sh
    ```
5. execute the installation **from within the VM** as root
    ```
    ./install.sh
    ```
