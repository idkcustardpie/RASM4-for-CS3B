   .equ	NODE_SIZE, 16
   .equ MAX_LEN, 20
   .equ R, 00
   .equ	T_RW, 01002
   .equ	C_RW, 0101
   .equ	RW_RW____, 0660

   .equ	AT_FDCWD, -100

   .global _start

   .data
szInFile:	.asciz "input.txt"
szOutFile:	.asciz "output.txt"
szTitle:	.asciz "\n\t\t\tRASM4 TEXT EDITOR\n"
szDataHeap:	.asciz "\t\tData Structure Heap Memory Consumption: "
szBytes:	.asciz " bytes\n"
szNumNodes:	.asciz "\t\tNumber of Nodes: "
szOptions1:	.asciz "\n<1> View all strings\n\n<2> Add string\n\t<a> fom Keyboard\n\t<b> from File. Static file named input.txt\n\n<3> Delete string. Given an index #, delete the entire sstring and de-allocate memory (including the node)."
szOptions2:	.asciz "\n\n<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n<5> string search. Regardless of case, return all strings that match he substring given."
szOptions3:	.asciz "\n\n<6> Save File (output.txt)\n\n<7> Quit\n\n"
szInput:	.asciz "Input: "
szChoice1:	.asciz "You chose option 1\n\n"
szChoice2a:	.asciz "You chose option 2a\n\n"
szChoice2b:	.asciz "You chose option 2b\n\n"
szChoice3:	.asciz "You chose option 3\n\n"
szChoice4:	.asciz "You chose option 4\n\n"
szInvalid:	.asciz "Please enter a valid option: "
szEntry:	.asciz "Enter a string: "
szDeleteIndex:	.asciz "Which index would you like to delete: "
szEdit:		.asciz "What would you like the new string to be: "
szEditIndex:	.asciz "Which index would you like to edit: "
szEOF:		.asciz "END OF FILE REACHED\n"
szERROR:	.asciz "UNABLE TO OPEN FILE\n"
szCloseBracket:	.asciz "] "

dbNodes:	.quad 0
dbByte:		.quad 0
//chChoice:	.byte 0x00
chLF:		.byte 0x0a
chOpenBracket:	.byte 0x5b
iFD:		.byte 0

headPtr:	.quad 0
tailPtr:	.quad 0

newNodePtr:	.quad 0
currentPtr:	.quad 0

szBuffer:	.skip 21
fileBuf:	.skip 512

   .text
_start:
   ldr	x0,=szTitle	// display the title of the program
   bl	putstring

   ldr	x0,=szDataHeap	// display the about of memory used by the program
   bl	putstring

   ldr	x0,=dbByte
   ldr	x0,[x0]

   ldr	x1,=szBuffer
   bl	int64asc

   ldr	x0,=szBuffer
   bl	putstring

   ldr	x0,=szBytes
   bl	putstring

   ldr	x0,=szNumNodes
   bl	putstring

   ldr	x0,=dbNodes
   ldr	x0,[x0]

   ldr	x1,=szBuffer
   bl	int64asc

   ldr	x0,=szBuffer
   bl	putstring

   ldr	x0,=szOptions1
   bl	putstring

   ldr	x0,=szOptions2
   bl	putstring

   ldr	x0,=szOptions3
   bl	putstring

   ldr	x0,=szInput
   bl	putstring

enter:
   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   ldrb	w0,[x0]
   //ldr	x1,=chChoice
   //strb	w0,[x1]

   //ldr	x0,=chChoice
   //ldr	x0,[x0]
   cmp	w0,#'1'
   beq	choice_one
   cmp	w0,#'2'
   beq	choice_two
   cmp	w0,#'3'
   beq	choice_three
   cmp	w0,#'4'
   beq	choice_four
   cmp	w0,#'7'
   beq	exit

   ldr	x0,=szInvalid
   bl	putstring

   b	enter

choice_one:
   ldr	x0,=szChoice1
   bl	putstring

   bl	traverse

   b	_start

choice_two:
   //ldr	x0,=szChoice2
   //bl	putstring
   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   ldrb	w0,[x0]

   cmp	w0, #'a'
   beq	choice_two_a

   cmp	w0, #'b'
   beq	choice_two_b

   ldr	x0,=szInvalid
   bl	putstring

   b	choice_two

choice_two_a:
   ldr	x0,=szChoice2a
   bl	putstring

   bl	user_insert

   b	_start

choice_two_b:
   ldr	x0,=szChoice2b
   bl	putstring

   bl	file_input

   b	_start

choice_three:
   ldr	x0,=szChoice3
   bl	putstring

   ldr	x0,=szDeleteIndex
   bl	putstring

   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   bl	ascint64

   bl	delete

   b	_start

choice_four:
   ldr	x0,=szChoice4
   bl	putstring

   ldr	x0,=szEditIndex
   bl	putstring

   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   bl	ascint64

   bl	edit

   b	_start

exit:
   /**** EXIT SEQUENCE ****/
   mov	x0,#0
   mov	x8, #93
   svc	0

traverse:
   str	x0,[SP,#-16]!
   str	x1,[SP,#-16]!
   str	x19,[SP,#-16]!
   str	x20,[SP,#-16]!
   str	x30,[SP,#-16]!
   ldr	x19,=headPtr
   mov	x20,#0
traverse_top:
   ldr	x19,[x19]

   cmp	x19,#0
   beq	traverse_exit

   //str	x19,[SP,#-16]!
   //str	x20,[SP,#-16]!

   ldr	x0,=chOpenBracket
   bl	putch

   //ldr	x20,[SP], #16

   mov	x0,x20
   ldr	x1,=szBuffer
   bl	int64asc

   ldr	x0,=szBuffer
   bl	putstring

   ldr	x0,=szCloseBracket
   bl	putstring

   ldr	x0,[x19]
   bl	putstring

   ldr	x0,=chLF
   bl	putch

   add	x20,x20,#1
   add	x19,x19,#8
   b	traverse_top

traverse_exit:
   ldr	x30,[SP], #16
   ldr	x20,[SP], #16
   ldr	x19,[SP], #16
   ldr	x1,[SP], #16
   ldr	x0,[SP], #16
   RET	LR

user_insert:
   str	x0,[SP, #-16]!
   str	x1,[SP, #-16]!
   str	x2,[SP, #-16]!
   str	x30,[SP, #-16]!

   mov	x0,NODE_SIZE
   bl	malloc

   ldr	x1,=newNodePtr
   str	x0,[x1]

   ldr	x0,=szEntry
   bl	putstring

   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   bl	String_copy

   ldr	x1,=newNodePtr
   ldr	x1,[x1]

   str	x0,[x1]

   ldr	x1,=newNodePtr
   ldr	x1,[x1]

   ldr	x0,=headPtr
   ldr	x0,[x0]
   cmp	x0,#0
   beq	empty_list

   ldr	x0,=tailPtr
   ldr	x0,[x0]
   add	x0,x0,#8

   str	x1,[x0]
   b	update_tail

empty_list:
   ldr	x0,=headPtr
   str	x1,[x0]

update_tail:
   ldr	x0,=tailPtr
   str	x1,[x0]

   //mov	x0,x1
   ldr	x0,[x1]
   bl	String_length

   ldr	x1,=dbByte
   ldr	x1,[x1]
   add	x1,x0,x1
   add	x1,x1,#16
   ldr	x0,=dbByte
   str	x1,[x0]

   ldr	x1,=dbNodes
   ldr	x1,[x1]
   add	x1,x1,#1
   ldr	x0,=dbNodes
   str	x1,[x0]

   ldr	x30,[SP], #16
   ldr	x2,[SP], #16
   ldr	x1,[SP], #16
   ldr	x0,[SP], #16

   RET	LR

/*
   Only adds empty strings to the list. The number of nodes added is correct tho
*/
file_input:
   str	x0,[SP,#-16]!
   str	x1,[SP,#-16]!
   str	x2,[SP,#-16]!
   str	x3,[SP,#-16]!
   str	x4,[SP,#-16]!
   str	x8,[SP,#-16]!
   str	x30,[SP,#-16]!

   mov	x0, #AT_FDCWD
   mov	x8, #56
   ldr	x1,=szInFile

   mov	x2, #R
   mov	x3, #RW_RW____
   svc	0

   cmp	x0,#0
   blt	ERROR

   ldr	x4,=iFD
   strb	w0,[x4]

file_top:
   mov	x0,NODE_SIZE	// allocate memory block of NODE_SIZE bytes
   bl	malloc

   ldr	x1,=newNodePtr	// store the address of the memory in newNodePtr
   str	x0,[x1]

   ldr	x1,=fileBuf	//

   bl	getline
   cmp	x0,#0x0
   beq	file_last

   ldr	x0,=fileBuf
   bl	String_copy

   ldr	x1,=newNodePtr
   ldr	x1,[x1]

   str	x0,[x1]

   ldr	x1,=newNodePtr
   ldr	x1,[x1]

   ldr	x0,=headPtr
   ldr	x0,[x0]
   cmp	x0,#0
   beq	empty_list_file

   ldr	x0,=tailPtr
   ldr	x0,[x0]
   add	x0,x0,#8

   str	x1,[x0]
   b	update_tail_file

empty_list_file:
   ldr	x0,=headPtr
   str	x1,[x0]

update_tail_file:
   ldr	x0,=tailPtr
   str	x1,[x0]

   //mov	x0,x1
   ldr	x0,[x1]
   bl	String_length

   ldr	x1,=dbByte
   ldr	x1,[x1]
   add	x1,x0,x1
   add	x1,x1,#16
   ldr	x0,=dbByte
   str	x1,[x0]

   ldr	x1,=dbNodes
   ldr	x1,[x1]
   add	x1,x1,#1
   ldr	x0,=dbNodes
   str	x1,[x0]

   ldr	x0,=iFD
   ldrb	w0,[x0]

   b	file_top

file_last:
   ldr	x0,=iFD
   ldrb	w0,[x0]

   mov	x8,#57
   svc	0

   ldr	x30,[SP], #16
   ldr	x8,[SP], #16
   ldr	x4,[SP], #16
   ldr	x3,[SP], #16
   ldr	x2,[SP], #16
   ldr	x1,[SP], #16
   ldr	x0,[SP], #16

   RET	LR

getchar:
   mov	x2, #1

   mov	x8, #63
   svc	0

   RET	LR

getline:
   str	x30,[SP, #-16]!

get_top:
   bl	getchar

   cmp	w0, #0x00
   beq	EOF

   ldrb	w2,[x1]
   cmp	w2, #0xa

   beq	EOLINE

   add	x1,x1,#1

   ldr	x0,=iFD
   ldrb	w0,[x0]
   b	get_top

EOLINE:
   add	x1,x1,#1
   mov	w2,#0
   strb	w2,[x1]
   b	skip

EOF:
   mov	x19,x0
   ldr	x0,=szEOF
   bl	putstring
   mov	x0,x19
   b	skip

ERROR:
   mov	x19, x0
   ldr	x0,=szERROR
   bl	putstring
   mov	x0,x19
   b	exit

skip:
   ldr	x30,[SP],#16

   RET	LR

/*
 When deleting last index, can no longer accept new strings. Not sure why. Tried updating tailPtr but still not working
*/

delete:
   str	x19,[SP,#-16]!
   str	x20,[SP,#-16]!
   str	x21,[SP,#-16]!
   str	x22,[SP,#-16]!
   str	x23,[SP,#-16]!
   str	x30,[SP,#-16]!

   ldr	x19,=headPtr
   mov	x20,x0
   add	x20,x20,#1
   ldr	x21,=dbNodes
   cmp	x20,x21
   beq	free_tail

   sub	x20,x20,#1
   mov	x21,#0

find_index:
   cmp	x21,x20
   bge	free_index

   ldr	x19,[x19]
   add	x19,x19,#8
   add	x21,x21,#1
   b	find_index

free_index:
   mov	x22,x19
   ldr	x19,[x19]

   //ldr	x0,[x19]
   mov	x0,x19
   bl	String_length

   ldr	x20,=dbByte
   ldr	x20,[x20]
   sub	x20,x20,x0
   sub	x20,x20,#16
   ldr	x21,=dbByte
   str	x20,[x21]

   ldr	x20,=dbNodes
   ldr	x20,[x20]
   sub	x21,x20,#1
   ldr	x20,=dbNodes
   str	x21,[x20]

   ldr	x23,[x19,#8]
   ldr	x0,[x19]
   bl	free

   mov	x0,x19
   bl	free

   str	x23,[x22]

   b	delete_exit

free_tail:
   ldr	x0,=tailPtr
   ldr	x1,[x0]
   ldr	x0,[x1]
   bl	free

   mov	x0,x1
   bl	free

   /* increment to node before what tailPtr was
      and assign that node ot tailPt*/
   //ldr	x19,[x19]
   sub	x20,x20,#2
   mov	x21,#0

find_previous:
   ldr	x19,[x19]
   cmp	x21,x20
   bge	move_tail

   add	x19,x19,#8
   add	x21,x21,#1
   b	find_previous

move_tail:
   ldr	x20,=tailPtr
   ldr	x19,[x19]
   str	x19,[x20]

delete_exit:
   ldr	x30,[SP],#16
   ldr	x23,[SP],#16
   ldr	x22,[SP],#16
   ldr	x21,[SP],#16
   ldr	x20,[SP],#16
   ldr	x19,[SP],#16

   RET	LR

edit:
   str	x19,[SP,#-16]!
   str	x20,[SP,#-16]!
   str	x21,[SP,#-16]!
   str	x30,[SP,#-16]!

   ldr	x19,=headPtr
   mov	x20,x0
   mov	x21,#0

edit_find:
   cmp	x21,x20
   bge	edit_string

   ldr	x19,[x19]
   add	x19,x19,#8
   add	x21,x21,#1
   b	edit_find

edit_string:
   ldr	x19,[x19]
   ldr	x0,[x19]
   bl	String_length

   ldr	x20,=dbByte
   ldr	x20,[x20]
   sub	x20,x20,x0
   ldr	x21,=dbByte
   str	x20,[x21]

   ldr	x0,[x19]
   bl	free

   ldr	x0,=szEdit
   bl	putstring

   ldr	x0,=szBuffer
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer
   bl	String_copy

   str	x0,[x19]

   bl	String_length

   ldr	x20,=dbByte
   ldr	x20,[x20]
   add	x20,x20,x0
   ldr	x21,=dbByte
   str	x20,[x21]

   ldr	x30,[SP],#16
   ldr	x21,[SP],#16
   ldr	x20,[SP],#16
   ldr	x19,[SP],#16

   RET	LR

   .end
