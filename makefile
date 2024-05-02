all:
	as -g -o driver.o driver.s
	as -g -o String_copy.o String_copy.s
	ld -o rasm4 /usr/lib/aarch64-linux-gnu/libc.so driver.o ../rasm4/String_copy.o ../obj/putstring-1.o ../obj/putch.o ../obj/String_length.o -dynamic-linker /lib/ld-linux-aarch64.so.1 ../obj/getstring.o ../obj/int64asc.o ../obj/ascint64.o
.PHONY: clean

clean:
	rm -f *.o run *~
