#ifndef BAUD_H
#define BAUD_H

#include "custom.h"

void uart_init(void);
void uart_sendbyte(u8 data);
u8 uart_recvbyte(void);

#endif /* BAUD_H */
