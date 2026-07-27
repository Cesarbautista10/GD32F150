#include <libopencm3/gd32/rcc.h>
#include <libopencm3/gd32/gpio.h>
#include "systick.h"

int main(void)
{
	rcc_periph_clock_enable(RCC_GPIOA);

	gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO7);
	gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO7);

	setup_systick();

	while (1) {
		gpio_set(GPIOA, GPIO7);
		mdelay(1000);
		gpio_clear(GPIOA, GPIO7);
		mdelay(1000);
	}
}
