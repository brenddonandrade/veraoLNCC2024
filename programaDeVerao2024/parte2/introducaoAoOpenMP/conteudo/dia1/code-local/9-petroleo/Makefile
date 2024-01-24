CC = gcc
CFLAGS = -lm -fopenmp -Wall -Wextra

all: 9-petroleo.exec

9-petroleo.exec: prog_aux_3D.o 9-kernel.o prog_kernel_3D.o prog_MOD3D_testKERNEL.o
	$(CC) $^ -o $@ $(CFLAGS)

clean:
	rm -f *.bin *.txt *.o *.optrpt *.exec
