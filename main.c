#include <avr/io.h>
#include <util/delay.h>

#include "custom.h"
#include "uart.h"

#define DEBOUNCE_TIME		1000


u8 dbounce(vu8 *pin, u8 idx)
{
	if (bit_is_clear(*pin, idx)) {
		_delay_us(DEBOUNCE_TIME);
		if (bit_is_clear(*pin, idx))
			return 1;
	}

	return 0;
}

int main(void)
{
	u8 btn_pressed = 0;

	BON(DDRB, DDB0);
	BOFF(DDRD, DDD2);
	BON(PORTD, PD2);

	uart_init();

	for (;;) {
		if (dbounce(&PIND, PIND2)) {
			if (btn_pressed == 0) {
				uart_sendstr("TEST TEST\n");
				BON(PORTB, PB0);
				_delay_ms(300);
				BOFF(PORTB, PB0);

				btn_pressed = 1;
			}
		} else {
			btn_pressed = 0;
		}
	}
}
