#include <libopencm3/gd32/rcc.h>
#include <libopencm3/gd32/gpio.h>

static void delay(void)
{
	/* Delay muy largo para HSI 8MHz */
	for (volatile int i = 0; i < 10000; i++) {
		__asm__("nop");
	}
}

int main(void)
{
	/* Habilitar reloj para GPIOA - usa HSI por defecto (8MHz) */
	rcc_periph_clock_enable(RCC_GPIOA);

	/* Configurar varios pines como salida para prueba */
	gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT,
		        GPIO_PUPD_NONE,
		        GPIO0 | GPIO1 | GPIO4 | GPIO5 | GPIO6 | GPIO7);
	gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, 
	                        GPIO0 | GPIO1 | GPIO4 | GPIO5 | GPIO6 | GPIO7);

	/* Bucle infinito parpadeando todos los pines */
	while(1) {
		gpio_set(GPIOA, GPIO0 | GPIO1 | GPIO4 | GPIO5 | GPIO6 | GPIO7);
		delay();
		delay();
		delay();
		gpio_clear(GPIOA, GPIO0 | GPIO1 | GPIO4 | GPIO5 | GPIO6 | GPIO7);
		delay();
		delay();
		delay();
	}
}
