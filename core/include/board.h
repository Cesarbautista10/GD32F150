#ifndef GD32F150_EXAMPLE_BOARD_H
#define GD32F150_EXAMPLE_BOARD_H
/* Reference LED: PA0 active high. Change to match the board. */
#ifndef LED_PIN_NUMBER
#define LED_PIN_NUMBER 0U
#endif
#ifndef LED_ACTIVE_LOW
#define LED_ACTIVE_LOW 0U
#endif
#if LED_PIN_NUMBER > 15
#error "LED_PIN_NUMBER must be between 0 and 15"
#endif
#define LED_PORT GPIOA
#define LED_PIN (1U << LED_PIN_NUMBER)
#endif
