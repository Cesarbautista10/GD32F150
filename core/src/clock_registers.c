#include "system.h"
static volatile uint32_t ticks;
void SysTick_Handler(void) { ++ticks; }
void clock_init(void)
{
    RCU_CTL0 |= RCU_CTL0_IRC8MEN;
    while (!(RCU_CTL0 & RCU_CTL0_IRC8MSTB)) {}
    RCU_CFG0 &= ~RCU_CFG0_SCS;
    while (RCU_CFG0 & RCU_CFG0_SCSS) {}
    RCU_CFG0 &= ~(RCU_CFG0_AHBPSC | RCU_CFG0_APB1PSC | RCU_CFG0_APB2PSC);
    SystemCoreClockUpdate();
    if (SysTick_Config(SystemCoreClock / 1000U) != 0U) {
        while (1) {}
    }
}

void delay_ms(uint32_t ms)
{
    uint32_t start = ticks;
    while ((uint32_t)(ticks - start) < ms) { __WFI(); }
}
