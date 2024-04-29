all: 
	as -g -o driver.o driver.s
	as -g -o String_length.o String_length.s
	as -g -o String_copy.o String_copy.s

	ld -o RASM4 /usr/lib/aarch64-linux-gnu/libc.so driver.o -dynamic-linker /lib/ld-linux-aarch64.so.1 String_length.o String_copy.o ../obj/putstring.o ../obj/putch.o ../obj/ascint64.o ../obj/hex64asc.o ../obj/int64asc.o ../obj/getstring.o

PHONY: clean
	
clean: rm -f *.o run *-