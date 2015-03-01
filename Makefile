
# ---- Project configuration --------------------------------------------------

# Name & folders
PROGNAME	= MyProgram
CONFIG_FILE 	= src/myconfig.h

# Target configuration
TARGET 		= atmega328p
CPU_FREQ 	= 16000000L
PROG_PORT	= /dev/ttyUSB0
PROG_RATE	= 57600

# Libraries
LIB_DIRS	= /path/to/libs/ /another/path/to/libs/
LIB_NAMES	= lib1 lib2 lib3

# Arduino configuration
ARDUINO_DIR	= /path/to/arduino/installation/

# Arduino libraries
ARDUINO_LIBS=LiquidCrystal SoftwareSerial



# ---- Toolchain --------------------------------------------------------------

CC 		= avr-gcc
CPP		= avr-g++
OBJCPY 		= avr-objcopy
SIZE		= avr-size

# Compiler config
CXXFLAGS 	= -DF_CPU=$(CPU_FREQ) -mmcu=$(TARGET) $(INCS) -I$(CORE_DIR) -I$(VARIANT_DIR) -imacros $(CONFIG_FILE)
CXXFLAGS	+= -Wall -fno-exceptions -ffunction-sections -fdata-sections -funsigned-char #-pedantic 
CXXFLAGS	+= -funsigned-bitfields -fpack-struct -fshort-enums 

CFLAGS 		= $(CXXFLAGS) -std=c99
CPPFLAGS 	= $(CXXFLAGS) -fpermissive

LDFLAGS		= -mmcu=$(TARGET)

# Optimizations
CXXFLAGS	+= -Os -mcall-prologues 
LDFLAGS		+= -Os -Wl,--gc-sections,--relax



# ---- Paths & file setup -----------------------------------------------------

SRCDIR		= src
OBJDIR		= obj
DISTDIR		= dist

# Arduino paths
CORE_DIR	:= $(ARDUINO_DIR)hardware/arduino/cores/arduino
INC_DIR		:= $(ARDUINO_DIR)hardware/tools/avr/lib/avr/include/
VARIANT_DIR	:= $(ARDUINO_DIR)hardware/arduino/variants/standard

# Object files and include paths
SOURCE_DIRS 	:= $(shell find src/ -type d) $(foreach DIR, $(ARDUINO_LIBS), $(ARDUINO_DIR)libraries/$(DIR))
SRCS		:= $(foreach DIR, $(SOURCE_DIRS), $(shell find $(DIR) -iname "*.c" -o -iname "*.cpp"))
OBJS 		:= $(patsubst %.cpp, $(OBJDIR)/%.o, $(patsubst %.c, $(OBJDIR)/%.o, $(notdir $(SRCS))))
INCS		:= $(foreach DIR, $(SOURCE_DIRS), -I$(DIR))

# Source search paths
VPATH 		:= $(SOURCE_DIRS)

# Library paths
LDPATHS     	:= $(foreach L, $(LIB_DIRS), -L$(L)) $(foreach n, $(LIB_NAMES), -l$(n))


# ---- Targets & rules --------------------------------------------------------

.PHONY: all
all: makedirs $(DISTDIR)/$(PROGNAME).hex

.PHONY: clean
clean:
	@rm -rf $(DISTDIR)/*
	@rm -rf $(OBJDIR)/*

.PHONY: flash
flash: $(DISTDIR)/$(PROGNAME).hex
	avrdude -carduino -p$(TARGET) -P$(PROG_PORT) -b$(PROG_RATE) -Uflash:w:$<

# Transform to hex
$(DISTDIR)/$(PROGNAME).hex: $(DISTDIR)/$(PROGNAME).elf
	@echo "Generating hex..."
	@$(OBJCPY) -O ihex $< $@
	@$(SIZE) $< 

# Link 
$(DISTDIR)/$(PROGNAME).elf: $(OBJS)
	@echo "Linking..."
	@$(CC) $(LDFLAGS) -o $@ $^ $(LDPATHS)

# Compile
$(OBJDIR)/%.o: %.cpp
	@$(CPP) -c $< $(CPPFLAGS) -o $@

$(OBJDIR)/%.o: %.c
	@$(CC) -c $< $(CFLAGS) -o $@


makedirs:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(DISTDIR)

