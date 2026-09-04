#include "system.h"
static volatile uint32_t ticks;
void SysTick_Handler(void) { ++ticks; }
void clock_init(void)
{
    rcu_osci_on(RCU_IRC8M);
    if (rcu_osci_stab_wait(RCU_IRC8M) != SUCCESS) {
        while (1) {}
    }
    rcu_system_clock_source_config(RCU_CKSYSSRC_IRC8M);
    while (rcu_system_clock_source_get() != RCU_SCSS_IRC8M) {}
    rcu_ahb_clock_config(RCU_AHB_CKSYS_DIV1);
    rcu_apb1_clock_config(RCU_APB1_CKAHB_DIV1);
    rcu_apb2_clock_config(RCU_APB2_CKAHB_DIV1);
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
