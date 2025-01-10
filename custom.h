#ifndef CUSTOM_H
#define CUSTOM_H

#define BSET(X, A)			((X) = _BV(A))			//Bit Set
#define BON(X, A)			((X) |= _BV(A))			//Bit On
#define BOFF(X, A)			((X) &= ~(_BV(A)))		//Bit Off
#define BTOG(X, A)			((X) ^= _BV(A))			//Bit Toggle

#define BSET2(X, A, B)		((X) = (_BV(A) | _BV(B)))
#define BON2(X, A, B) 		((X) |= (_BV(A) | _BV(B)))
#define BOFF2(X, A, B)		((X) &= ~((_BV(A) | _BV(B))))
#define BTOG2(X, A, B)		((X) ^= (_BV(A) | _BV(B)))

typedef uint8_t				u8;
typedef uint16_t			u16;

typedef volatile uint8_t	vu8;
typedef volatile uint16_t	vu16;

#endif /* CUSTOM_H */
