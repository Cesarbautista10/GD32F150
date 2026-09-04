# GD32F150 blink registers

LED PA0 activo en alto, transiciones cada 100 ms.
Reloj interno de 8 MHz. Consultar el README del micro para memoria y cableado.

```sh
make gd32 GD32_EXAMPLE=blink GD32_IMPL=registers
cmake --preset gd32-blink-registers
cmake --build --preset gd32-blink-registers
```

Desde el directorio del micro: `make EXAMPLE=blink IMPL=registers`.
Pendiente verificar en placa.
