# GD32F150 i2c spl

I2C0: PB6/SCL, PB7/SDA (AF1), dirección `0x42`, 100 kHz.
Escribir un byte y leer exactamente un byte en transacciones separadas.
Usar pull-ups externos a 3,3 V y tierra común.
Reloj interno de 8 MHz. Consultar el README del micro para memoria y cableado.

```sh
make gd32 GD32_EXAMPLE=i2c_slave GD32_IMPL=spl
cmake --preset gd32-i2c-spl
cmake --build --preset gd32-i2c-spl
```

Desde el directorio del micro: `make EXAMPLE=i2c_slave IMPL=spl`.
Pendiente verificar en placa.
