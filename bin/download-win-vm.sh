#!/bin/bash
wget -O vm-windows.zip https://aka.ms/windev_VM_virtualbox --show-progress --progress=bar:force
unzip -o vm-windows.zip
rm vm-windows.zip