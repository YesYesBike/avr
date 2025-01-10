#include <avr/io.h>
#include <util/delay.h>

#include "custom.h"

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
