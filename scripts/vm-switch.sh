#!/bin/bash
# Script para alternar entre VirtualBox y KVM
# Uso:
#   vm-switch vbox   -> Descarga KVM para usar VirtualBox
#   vm-switch kvm    -> Carga KVM para usar QEMU/virt-manager

case "$1" in
    vbox)
        echo "[+] Desactivando KVM para VirtualBox..."
        sudo modprobe -r kvm_amd 2>/dev/null
        sudo modprobe -r kvm 2>/dev/null
        echo "[+] KVM desactivado. Ahora puedes usar VirtualBox."
        ;;
    kvm)
        echo "[+] Activando KVM para QEMU/virt-manager..."
        sudo modprobe kvm
        sudo modprobe kvm_amd
        echo "[+] KVM activado."
        ;;
    *)
        echo "Uso: vm-switch {vbox|kvm}"
        ;;
esac
