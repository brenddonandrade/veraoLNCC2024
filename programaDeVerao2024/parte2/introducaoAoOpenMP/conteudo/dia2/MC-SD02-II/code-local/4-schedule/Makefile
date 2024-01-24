#COMPILER = clang-omp
COMPILER = gcc
FLAGS = -fopenmp -Wall -Wextra

all: 4-schedule.exec
	@echo "Compiled!"

%.exec: %.o
	$(COMPILER) -o $@ $+ $(FLAGS)

%.o: %.c
	$(COMPILER) -o $@ -c $< $(FLAGS)

clean:
	rm -f *.o *.exec *.exec
