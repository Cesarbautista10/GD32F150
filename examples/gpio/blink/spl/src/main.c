#include "system.h"
#include "board.h"

int main(void)
{
    clock_init();
    rcu_periph_clock_enable(RCU_GPIOA);
    gpio_bit_write(LED_PORT, LED_PIN, LED_ACTIVE_LOW ? SET : RESET);
    gpio_mode_set(LED_PORT, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, LED_PIN);
    gpio_output_options_set(LED_PORT, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, LED_PIN);
    while (1) {
        gpio_bit_write(LED_PORT, LED_PIN, LED_ACTIVE_LOW ? RESET : SET);
        delay_ms(100U);
        gpio_bit_write(LED_PORT, LED_PIN, LED_ACTIVE_LOW ? SET : RESET);
        delay_ms(100U);
    }
}
