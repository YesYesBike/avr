#ifndef UART_H
#define UART_H

#include "custom.h"

void uart_init(void);
void uart_sendbyte(u8 data);
u8 uart_recvbyte(void);
void uart_sendstr(const char *p);

#endif /* UART_H */
