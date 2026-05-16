#!/bin/bash
# Script de depuración para GD32F150

pyocd commander --target gd32f150g8 --pack ./GigaDevice.GD32F1x0_DFP.3.2.0.pack <<EOF
halt
# Verificar Stack Pointer inicial
read32 0x08000000
# Verificar Reset Vector
read32 0x08000004
# Verificar registro PC
reg pc
# Verificar registro SP
reg sp
# Leer registro de control del reloj
read32 0x40021000
# Leer registro GPIOA
read32 0x48000000
# Reset y ejecutar
reset
continue
exit
EOF
