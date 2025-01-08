#include <avr/io.h>
#include <util/delay.h>
#include <util/setbaud.h>

#include "custom.h"
#include "baud.h"

int main(void)
{
	u8 serial;

	uart_init();

	for (;;) {
		serial = uart_recvbyte();
		uart_sendbyte(serial - 1);
	}
}
