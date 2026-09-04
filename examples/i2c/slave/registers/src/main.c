#include "transport.h"

void bus_init(void)
{
    RCU_APB1RST |= RCU_APB1RST_I2C0RST;
    RCU_APB1RST &= ~RCU_APB1RST_I2C0RST;
    I2C_CTL0(I2C0) = 0U;
    /* APB1 = 8 MHz, standard mode 100 kHz, 7-bit own address. */
    I2C_CTL1(I2C0) = 8U;
    I2C_CKCFG(I2C0) = 40U;
    I2C_RT(I2C0) = 9U;
    I2C_SADDR0(I2C0) = I2C_ADDFORMAT_7BITS | (SLAVE_ADDRESS << 1);
    I2C_CTL0(I2C0) = I2C_CTL0_I2CEN | I2C_CTL0_ACKEN;
}


int main(void)
{
    clock_init();
    RCU_AHBEN |= RCU_AHBEN_PBEN;
    RCU_APB1EN |= RCU_APB1EN_I2C0EN;
    (void)RCU_AHBEN;
    GPIO_CTL(GPIOB) = (GPIO_CTL(GPIOB) & ~(0xFU << 12)) | (0xAU << 12);
    GPIO_OMODE(GPIOB) |= (1U << 6) | (1U << 7);
    GPIO_OSPD(GPIOB) = (GPIO_OSPD(GPIOB) & ~(0xFU << 12)) | (0xFU << 12);
    GPIO_PUD(GPIOB) = (GPIO_PUD(GPIOB) & ~(0xFU << 12)) | (0x5U << 12);
    GPIO_AFSEL0(GPIOB) = (GPIO_AFSEL0(GPIOB) & ~(0xFFU << 24)) | (0x11U << 24);
    bus_init();
    while (1) { bus_poll(); }
}
