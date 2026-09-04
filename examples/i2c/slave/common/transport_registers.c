#include "transport.h"

void bus_poll(void)
{
    static uint8_t reply;
    static uint8_t transmitting;
    uint32_t status = I2C_STAT0(I2C0);
    if (status & (I2C_STAT0_BERR | I2C_STAT0_LOSTARB | I2C_STAT0_OUERR)) {
        transmitting = 0U;
        bus_init();
        return;
    }
    if (status & I2C_STAT0_RBNE) reply = (uint8_t)I2C_DATA(I2C0);
    if (status & I2C_STAT0_AERR) {
        I2C_STAT0(I2C0) &= ~I2C_STAT0_AERR;
        transmitting = 0U;
    }
    if (status & I2C_STAT0_STPDET) {
        /* STAT0 read followed by CTL0 write clears STOP. */
        I2C_CTL0(I2C0) |= I2C_CTL0_I2CEN;
        transmitting = 0U;
    }
    if (status & I2C_STAT0_ADDSEND) {
        /* STAT0/STAT1 reads clear address match. */
        transmitting = (I2C_STAT1(I2C0) & I2C_STAT1_TRS) != 0U;
    }
    if (transmitting && (I2C_STAT0(I2C0) & I2C_STAT0_TBE)) {
        I2C_DATA(I2C0) = reply;
        transmitting = 0U; /* Exactly one byte, no stale prefetch. */
    }
}
