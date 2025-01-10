#include <avr/io.h>
#include <util/setbaud.h>

#include "uart.h"
#include "custom.h"

void uart_init(void)
{
	UBRR0H = UBRRH_VALUE;
	UBRR0L = UBRRL_VALUE;
#if USE_2X
	BON(UCSR0A, U2X0);
#else
	BOFF(UCSR0A, U2X0);
#endif
	BSET2(UCSR0B, TXEN0, RXEN0);
	BSET2(UCSR0C, UCSZ01, UCSZ00);
}

void uart_sendbyte(u8 data)
{
	loop_until_bit_is_set(UCSR0A, UDRE0);
	UDR0 = data;
}

u8 uart_recvbyte(void)
{
	loop_until_bit_is_set(UCSR0A, RXC0);
	return UDR0;
}

void uart_sendstr(const char *p)
{
	while (*p)
		uart_sendbyte(*p++);
}
