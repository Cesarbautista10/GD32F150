#ifndef GD32F150_TRANSPORT_H
#define GD32F150_TRANSPORT_H
#include "system.h"
#define SLAVE_ADDRESS 0x42U
void bus_init(void);
void bus_poll(void);
#endif
