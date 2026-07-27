# blink_pa6

Ejemplo mínimo para GD32F150 (GD32F150G8, Cortex-M3): enciende **PA6** un
segundo, lo apaga un segundo, en bucle. Sirve como caso de prueba end-to-end
(compilar → linkear → flashear con OpenOCD) sobre los ajustes que se hicieron
al toolchain del repo.

## Archivos

| Archivo             | Qué hace |
|----------------------|----------|
| `blinky.c`            | `main()`: habilita reloj de GPIOA, configura PA6 como salida push-pull y alterna `gpio_set`/`gpio_clear` con `mdelay(1000)` entre cada cambio. |
| `systick.c` / `.h`    | Temporizador de milisegundos vía SysTick (copiado de `project/gcc`), usado para el `mdelay(1000)`. |
| `ld/gd32f1x0x8.ld`    | Linker script escrito a mano para GD32F150x8 (64 KiB flash / 8 KiB RAM). |
| `openocd.cfg`         | Config de OpenOCD: adaptador CMSIS-DAP + `target/stm32f1x.cfg` (el GD32F1x0 comparte IP de flash con STM32F1). |
| `Makefile`            | Compila `blinky_f1x0x8.elf/.bin/.hex` y expone `make flash-openocd` y `make flash` (pyocd). |
| `libopencm3`          | Symlink a `../libopencm3` (submódulo del repo). Ignorado en git; no se versiona. |

## Por qué existe esta carpeta (contexto de los cambios previos)

Al intentar compilar/flashear `project/gcc` y `mini/gcc` con OpenOCD nos
encontramos con varios problemas que se corrigieron y que esta carpeta
reutiliza ya resueltos:

1. **Submódulo `libopencm3` sin inicializar.** Había que correr
   `git submodule update --init --recursive`.
2. **Symlink `libopencm3` faltante.** Los `.gitignore` de cada carpeta de
   proyecto ignoran `/libopencm3` porque se espera un symlink local (no
   versionado) al submódulo en la raíz del repo — nunca se había creado.
3. **Linker script inexistente.** El Makefile original apuntaba a
   `libopencm3/lib/gd32/f1x0/gd32f1x0x4.ld`, un archivo que **libopencm3
   nunca genera** para GD32 (su generador de linker scripts, `genlink`, no
   tiene entradas GD32 en `ld/devices.data`). Además el sufijo `x4` (16 KiB)
   no correspondía al chip real usado en los scripts de flasheo/debug
   (GD32F150**G8** = 64 KiB flash / 8 KiB RAM). Se escribió a mano
   `ld/gd32f1x0x8.ld` con el layout correcto.
4. **Adaptador de depuración mal identificado.** El `openocd.cfg` inicial
   asumía un ST-Link (`interface/stlink.cfg`), pero el debugger conectado es
   en realidad un **CMSIS-DAP** (WCH-LinkE, `lsusb` → `1a86:8011`). Con
   `interface/stlink.cfg` OpenOCD fallaba con `Error: open failed` porque
   buscaba un dispositivo que no existía en el bus. Se cambió a
   `interface/cmsis-dap.cfg`.
5. **CPUTAPID.** El IDCODE SWD real del GD32F150 (`0x1ba01477`) no coincide
   con el que espera `target/stm32f1x.cfg` por defecto, así que se fuerza
   con `set CPUTAPID 0x1ba01477` antes de cargar el target script.

Con esos cinco ajustes, `project/gcc` y `mini/gcc` compilan y flashean sin
errores vía `make flash-openocd`. `blink_pa6` parte de esa misma base ya
corregida.

## Build

```bash
cd blink_pa6
make
```

Esto genera `blinky_f1x0x8.elf`, `.bin` y `.hex`. Verificado: ~1.4 KB de
código de 64 KiB de flash disponibles.

## Flashear con OpenOCD

Con el debugger CMSIS-DAP conectado (verifica con `lsusb` que aparezca algo
como `1a86:8011`):

```bash
make flash-openocd
```

Equivale a:

```bash
openocd -f openocd.cfg -c "program blinky_f1x0x8.elf verify reset exit"
```

Salida esperada (resumida):

```
Info : CMSIS-DAP: SWD supported
Info : [stm32f1x.cpu] Cortex-M3 r2p1 processor detected
** Programming Started **
Info : device id = 0x13030410
Info : flash size = 64 KiB
** Programming Finished **
** Verify Started **
** Verified OK **
** Resetting Target **
```

Si aparece `Error: unable to find a matching CMSIS-DAP device` o
`Error: open failed`, el adaptador no está conectado o no lo reconoce el
sistema — revisa `lsusb`.

Si usas otro adaptador (ST-Link, J-Link), edita `openocd.cfg` y cambia la
línea `source [find interface/cmsis-dap.cfg]` por la que corresponda
(`interface/stlink.cfg`, `interface/jlink.cfg`, etc).

## Flashear con pyocd (alternativa)

Igual que en `project/gcc`, pero reutilizando el `.pack` de GigaDevice que ya
está en esa carpeta (no se duplicó aquí para no repetir varios MB):

```bash
make flash
```

Equivale a:

```bash
pyocd load blinky_f1x0x8.elf \
  --target gd32f150g8 \
  --pack ../project/gcc/GigaDevice.GD32F1x0_DFP.3.2.0.pack
```

Notas:
- El `--pack` debe ser el archivo `.pack` (zip), no el `.pdsc` suelto de
  `project/gcc/gd32pack/` — pyocd lo rechaza con
  `Failed to open CMSIS-Pack: File is not a zip file` si le pasas el `.pdsc`.
- pyocd puede imprimir una excepción de un hilo `load-svd` al parsear el SVD
  del pack (`XML or text declaration not at start of entity`) — es un
  problema del archivo de descripción de registros incluido en el pack, no
  afecta el flasheo.
- Si el binario ya está flasheado (por ejemplo porque antes usaste
  `flash-openocd`), pyocd detecta que el contenido no cambió e imprime
  `programmed 0 bytes ... skipped N bytes` — no es un error, solo evitó
  reescribir flash innecesariamente.

## Qué evaluar / criterio de éxito

- `make` compila sin warnings ni errores.
- `make flash-openocd` termina con `** Verified OK **`.
- Al resetear la placa, el LED en PA6 (o el pin que hayas puenteado a PA6)
  parpadea a 1 Hz: 1 s encendido, 1 s apagado.

Si tu placa no tiene un LED cableado directo a PA6, conecta un LED con su
resistencia (~330 Ω) entre PA6 y GND, o usa un multímetro/osciloscopio en
PA6 para confirmar el toggle de 1 Hz.
