CC = gcc
CFLAGS = -lm -fopenmp -Wall -Wextra -march=native

OBJSUM := $(patsubst %.c,%.o,$(wildcard src/*.c))
OBJSUMF := $(patsubst %.c,%.exec,$(wildcard src/*.c))

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

all: main.o dot
	@echo "Compiled!"

%.exec: %.o
	$(CC) $(CFLAGS) -o $@ $< main.o

dot: $(OBJSUMF)

clean:
	rm -rf main.o *.optrpt $(OBJSUM) $(OBJSUMF)