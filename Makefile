CC = avr-gcc
LD = avr-ld
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
NM = avr-nm
AVRDUDE = avrdude
RM = rm -f

MCU = atmega328p
#F_CPU = 16000000UL
F_CPU = 8000000UL
BAUD = 9600

TARGET = led
SRC = led.c baud.c
OBJ = $(SRC:.c=.o)
#LST = $(SRC:.c=.lst)

CFLAGS := -DF_CPU=$(F_CPU)
CFLAGS += -DBAUD=$(BAUD)
CFLAGS += -mmcu=$(MCU)
CFLAGS += -Os
CFLAGS += -std=gnu99
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -Wall -Wstrict-prototypes
#CFLAGS += -Wa,-adhlns=$(<:.c=.lst)

LDFLAGS = -Wl,--gc-sections
LDFLAGS += -Wl,--print-gc-sections	

AVRDUDE_MCU := $(MCU)
AVRDUDE_PROGRAMMER = stk500v2
AVRDUDE_BAUD = 19200
AVRDUDE_DEV = /dev/ttyACM1

AVRDUDE_FLAG := -p $(AVRDUDE_MCU)
AVRDUDE_FLAG += -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAG += -P $(AVRDUDE_DEV)
AVRDUDE_FLAG += -b $(AVRDUDE_BAUD)
#AVRDUDE_FLAG += -B 125kHz
AVRDUDE_FLAG += -v -V

LFUSE = 0xE2
#HFUSE = asdf

comp: $(TARGET).hex

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET).elf: $(OBJ)
	$(CC) -mmcu=$(MCU) -o $@ $^ $(LDFLAGS)

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@


up: $(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_FLAG) -Uflash:w:$(TARGET).hex

lfuse:
	$(AVRDUDE) $(AVRDUDE_FLAG) -Ulfuse:w:$(LFUSE):m

hfuse:
	$(AVRDUDE) $(AVRDUDE_FLAG) -Uhfuse:w:$(HFUSE):m


size: $(TARGET).elf
	$(SIZE) -C --mcu=$(AVRDUDE_MCU) $<

nm: $(TARGET).elf
	$(NM) -S --size-sort -t decimal $<

dump: $(TARGET).elf
	$(OBJDUMP) -f $<

clean:
	$(RM) $(TARGET).hex $(TARGET).elf $(OBJ)

.PHONY: comp up clean size dump nm
