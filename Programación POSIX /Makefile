.PHONY: clean veryclean dist

CC = gcc
CFLAGS = -Wall -g
INCLUDES = -I.
LFLAGS = #-L.
LIBS = #-lrt -lpthread

MAIN = ejercicio1 ejercicio2 ejercicio3 ejercicio4-cliente ejercicio4-servidor

all:    $(MAIN)
	@echo  Terminado

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) *.o *~ $(MAIN) log-servidor.txt log-*.txt

dist: 
	tar zcvf pas-practica3.tar.gz *.c Makefile htdocs/*

