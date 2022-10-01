mkdir xv6
unzip -d xv6 xv6.zip

./build_qemu.sh

echo "export XV6=`realpath xv6`" >> $HOME/.bashrc
