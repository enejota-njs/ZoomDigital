all:
	gcc -c -o assembly.o assembly.s
	gcc -c -o test_code.o test_code.c -std=c99
	gcc -o zoom_digital assembly.o test_code.o

clean:
	rm -f *.o zoom_digital   