#include "system.h"
#include "board.h"

int main(void)
{
    clock_init();
    RCU_AHBEN |= RCU_AHBEN_PAEN;
    (void)RCU_AHBEN;
    if (LED_ACTIVE_LOW) GPIO_BOP(LED_PORT) = LED_PIN;
    else GPIO_BC(LED_PORT) = LED_PIN;
    GPIO_OMODE(LED_PORT) &= ~LED_PIN;
    GPIO_OSPD(LED_PORT) &= ~(3U << (LED_PIN_NUMBER * 2U));
    GPIO_PUD(LED_PORT) &= ~(3U << (LED_PIN_NUMBER * 2U));
    GPIO_CTL(LED_PORT) = (GPIO_CTL(LED_PORT) & ~(3U << (LED_PIN_NUMBER * 2U))) |
                        (1U << (LED_PIN_NUMBER * 2U));
    while (1) {
        if (LED_ACTIVE_LOW) GPIO_BC(LED_PORT) = LED_PIN;
        else GPIO_BOP(LED_PORT) = LED_PIN;
        delay_ms(100U);
        if (LED_ACTIVE_LOW) GPIO_BOP(LED_PORT) = LED_PIN;
        else GPIO_BC(LED_PORT) = LED_PIN;
        delay_ms(100U);
    }
}
