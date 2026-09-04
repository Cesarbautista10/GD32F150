# GD32F150

Integrado en Make y CMake con CMSIS-Core 6 compartido. Las variantes son
`spl` (biblioteca estándar GigaDevice), `registers` (registros) y `mixed`.
No se presentan como HAL/LL de STM32.

```text
core/                              Arranque GCC, linker y reloj
examples/gpio/blink/{spl,registers,mixed}/
examples/i2c/slave/{spl,registers,mixed}/
src/                               CMSIS-Device y drivers importados
project/, mini/, gd32pack/          Referencias originales
```

## Compilación

Desde la raíz:

```sh
make gd32
make gd32 GD32_EXAMPLE=blink GD32_IMPL=registers
make gd32 GD32_EXAMPLE=i2c_slave GD32_IMPL=spl
cmake --preset gd32-i2c-mixed
cmake --build --preset gd32-i2c-mixed
```

Desde este directorio: `make EXAMPLE=blink IMPL=mixed`.
Hay presets `gd32` y `gd32-{blink,i2c}-{spl,registers,mixed}`.
CMake también acepta `-DGD32_EXAMPLE=i2c_slave -DGD32_IMPL=registers`.
`make firmware` y el preset `default` incluyen GD32.

Make genera `build/<ejemplo>/<implementación>/<flash_kb>/` dentro del micro.
CMake genera `build/<preset>/gd32/<ejemplo>/<implementación>/`.
Cada ejemplo permite añadir fuentes e includes con `libraries.mk` y
`libraries.cmake`. La compilación activa no necesita el submódulo libopencm3.

## Memoria y placa

La referencia exacta y el cableado del usuario aún no están confirmados.
La selección inicial es densidad x4: **16 KiB Flash / 4 KiB RAM**.
Las capacidades se toman del [paquete de dispositivo incluido](gd32pack/gd32pack/GigaDevice.GD32F1x0_DFP.pdsc).

| Densidad | Flash | RAM | Make | CMake |
| --- | --- | --- | --- | --- |
| x4 | 16 KiB | 4 KiB | `FLASH_KB=16` | `-DGD32_FLASH_KB=16` |
| x6 | 32 KiB | 4 KiB | `FLASH_KB=32` | `-DGD32_FLASH_KB=32` |
| x8 | 64 KiB | 8 KiB | `FLASH_KB=64` | `-DGD32_FLASH_KB=64` |

El LED de referencia es **PA0 activo en alto**, con transiciones cada 100 ms.
Ajustar `core/include/board.h` al cableado real. El reloj es **IRC8M a 8 MHz**
desde el arranque y no depende de cristal externo.

I2C0 usa **PB6/SCL y PB7/SDA, AF1**, dirección de siete bits `0x42` y 100 kHz.
Conectar pull-ups externos a 3,3 V y tierra común; comprobar que el encapsulado
expone ambos pines. Escribir un byte y después leer exactamente un byte en
transacciones separadas devuelve el último valor, inicialmente cero.
No implementa el protocolo avanzado I2C/ADC de PY32.

| Variante | Blink | I2C esclavo |
| --- | --- | --- |
| SPL | Reloj y GPIO SPL | Reloj, GPIO y polling I2C SPL |
| Registers | Reloj y GPIO por registros | Reloj, GPIO e I2C por registros |
| Mixed | Reloj SPL y GPIO por registros | Inicialización SPL y transporte por registros |

SysTick y el arranque utilizan CMSIS en todas las variantes.
Se verifican compilación y enlace; las pruebas de LED, bus y recuperación
requieren la placa física. GNU ld puede advertir que Newlib no aporta la
sección `.note.GNU-stack`; no es una advertencia del código de aplicación.

## Procedencia y adaptaciones

El repositorio importado [SoCXin/GD32F150](https://github.com/SoCXin/GD32F150)
conserva su contenido original en `src/`, `project/`, `mini/` y `gd32pack/`.
El [README original](docs/upstream-readme.md) se conserva aparte.
El código compilado de periféricos procede de
`src/GD32F1x0_standard_peripheral`, versión declarada V3.1.0, 2017.

- `core/src/system_gd32f1x0.c`: copia del archivo CMSIS incluido, con la selección
  de reloj cambiada de PLL/HXTAL 72 MHz a IRC8M 8 MHz; conserva licencia y avisos.
- `core/src/startup_gd32f150.s`: adaptación GCC con los 90 vectores en el mismo
  orden del startup ARM incluido; inicializa datos/BSS y ejecuta SystemInit,
  constructores y main.
- `core/gd32f150.ld`: linker local parametrizado por Flash y RAM.
- `core/include/gd32f1x0_libopt.h`: selección local de cabeceras de periféricos.

`core/UPSTREAM.sha256` registra los archivos originales usados como referencia.
Se comprueba desde este directorio con `sha256sum -c core/UPSTREAM.sha256`.
