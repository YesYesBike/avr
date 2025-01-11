CC = avr-gcc
LD = avr-ld
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
NM = avr-nm
AVRDUDE = avrdude
RM = rm -f

CC_PC = cc
CFLAGS_PC = 
LDFLAGS_PC = 

MCU = atmega328p
#MCU = atmega2560
#F_CPU = 16000000UL
F_CPU = 8000000UL
BAUD = 9600

TARGET = a.out
TARGET_AVR = lol
SRC = main.c uart.c
OBJ = $(SRC:.c=.o)
SRC_PC = pc_main.c
OBJ_PC = $(SRC_PC:.c=.o)
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


#Default Option
first: comp


#AVR
comp: $(TARGET_AVR).hex

$(TARGET_AVR).hex: $(TARGET_AVR).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(TARGET_AVR).elf: $(OBJ)
	$(CC) -mmcu=$(MCU) -o $@ $^ $(LDFLAGS)


#PC
pc: $(TARGET)

$(TARGET): $(OBJ_PC)
	$(CC_PC) -o $@ $^


#OBJ_AVR
main.o: custom.h uart.h
uart.o: custom.h uart.h

#OBJ_PC
pc_main.o: pc_main.c
	$(CC_PC) -c $(CFLAGS_PC) -o $@ $<


#Other Options
up: $(TARGET_AVR).hex
	$(AVRDUDE) $(AVRDUDE_FLAG) -Uflash:w:$(TARGET_AVR).hex

lfuse:
	$(AVRDUDE) $(AVRDUDE_FLAG) -Ulfuse:w:$(LFUSE):m

hfuse:
	$(AVRDUDE) $(AVRDUDE_FLAG) -Uhfuse:w:$(HFUSE):m


size: $(TARGET_AVR).elf
	$(SIZE) -C --mcu=$(AVRDUDE_MCU) $<

nm: $(TARGET_AVR).elf
	$(NM) -S --size-sort -t decimal $<

dump: $(TARGET_AVR).elf
	$(OBJDUMP) -f $<

clean:
	$(RM) $(TARGET_AVR).hex $(TARGET_AVR).elf *.o

.PHONY: first comp up clean size dump nm pc
