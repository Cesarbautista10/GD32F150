#include "transport.h"

void bus_init(void)
{
    i2c_deinit(I2C0);
    i2c_clock_config(I2C0, 100000U, I2C_DTCY_2);
    i2c_mode_addr_config(I2C0, I2C_I2CMODE_ENABLE, I2C_ADDFORMAT_7BITS,
                         SLAVE_ADDRESS << 1);
    i2c_enable(I2C0);
    i2c_ack_config(I2C0, I2C_ACK_ENABLE);
}

void bus_poll(void)
{
    static uint8_t reply;
    static uint8_t transmitting;
    if (i2c_flag_get(I2C0, I2C_FLAG_BERR) ||
        i2c_flag_get(I2C0, I2C_FLAG_LOSTARB) || i2c_flag_get(I2C0, I2C_FLAG_OUERR)) {
        transmitting = 0U;
        bus_init();
        return;
    }
    if (i2c_flag_get(I2C0, I2C_FLAG_RBNE)) reply = i2c_data_receive(I2C0);
    if (i2c_flag_get(I2C0, I2C_FLAG_AERR)) {
        i2c_flag_clear(I2C0, I2C_FLAG_AERR);
        transmitting = 0U;
    }
    if (i2c_flag_get(I2C0, I2C_FLAG_STPDET)) {
        /* Flag read then control write is the required STOP clear sequence. */
        i2c_enable(I2C0);
        transmitting = 0U;
    }
    if (i2c_flag_get(I2C0, I2C_FLAG_ADDSEND)) {
        transmitting = i2c_flag_get(I2C0, I2C_FLAG_TRS) != RESET;
    }
    if (transmitting && i2c_flag_get(I2C0, I2C_FLAG_TBE)) {
        i2c_data_transmit(I2C0, reply);
        transmitting = 0U;
    }
}

int main(void)
{
    clock_init();
    rcu_periph_clock_enable(RCU_GPIOB);
    rcu_periph_clock_enable(RCU_I2C0);
    gpio_af_set(GPIOB, GPIO_AF_1, GPIO_PIN_6 | GPIO_PIN_7);
    gpio_mode_set(GPIOB, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_6 | GPIO_PIN_7);
    gpio_output_options_set(GPIOB, GPIO_OTYPE_OD, GPIO_OSPEED_50MHZ,
                            GPIO_PIN_6 | GPIO_PIN_7);
    bus_init();
    while (1) { bus_poll(); }
}
