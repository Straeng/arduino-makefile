# arduino-makefile
Simple makefile for building Arduino projects in Linux. 

### Project structure
The makefile expects the project to be on the form described below.
- /Makefile
- /src/
- /obj/
- /dist/

### Targets
- clean
- all
- flash (might require sudo access)

### Requirements
- avr-gcc
- avrdude

### Configuration
- PROGNAME: Name of project (produced hex file will have this name)
- CONFIG_FILE: header (.h) file containing global configuration (defines)
- TARGET: Name of the target AVR
- CPU_FREQ: Oscillator frequency
- PROG_PORT: Serial port used for programming through AVRDUDE
- PROG_RATE: Seial baud rate
- LIB_DIRS: List of directories in which to search for libraries used in the project
- LIB_NAMES: List of libraries used (for example: m core)
- ARDUINO_DIR: Path to arduino installation root dir
- ARDUINO_LIBS: List of arduino "libs" used in the project (for example: LiquidCrystal)
