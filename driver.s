   .equ	NODE_SIZE, 16
   .equ MAX_LEN, 20

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
szOptions3:	.asciz "\n\n<6> Save File (outpt.txt)\n\n<7> Quit\n\n"
szInput:	.asciz "Input: "
szChoice1:	.asciz "You chose option 1\n\n"
szChoice2a:	.asciz "You chose option 2a\n\n"
szChoice2b:	.asciz "You chose option 2b\n\n"
szChoice3:	.asciz "You chose option 3\n\n"
szChoice4:	.asciz "You chose option 4\n\n"
szInvalid:	.asciz "Please enter a valid option: "
szEntry:	.asciz "Enter a string: "

dbByte:		.quad 0
chChoice:	.byte 0x00
chLF:		.byte 0x0a

headPtr:	.quad 0
tailPtr:	.quad 0

newNodePtr:	.quad 0
currentPtr:	.quad 0

szBuffer:	.skip 21

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

   b	_start

choice_three:
   ldr	x0,=szChoice3
   bl	putstring

   b	_start

choice_four:
   ldr	x0,=szChoice4
   bl	putstring

   b	_start

exit:
   /**** EXIT SEQUENCE ****/
   mov	x0,#0
   mov	x8, #93
   svc	0

traverse:
   str	x19,[SP,#-16]!
   str	x30,[SP,#-16]!
   ldr	x19,=headPtr
traverse_top:
   ldr	x19,[x19]

   cmp	x19,#0
   beq	traverse_exit

   ldr	x0,[x19]
   bl	putstring

   add	x19,x19,#8
   b	traverse_top

traverse_exit:
   ldr	x30,[SP], #16
   ldr	x19,[SP], #16
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
   bne	insert

   ldr	x0,=headPtr
   str	x1,[x0]

   b	User_input_exit

insert:
   ldr	x0,=headPtr
   ldr	x0,[x0]
   add	x0,x0,#8
insert_loop:
   //add	x0,x0,#8
   ldr	x2,[x0]
   cmp	x2,#0
   beq	save

   ldr	x0,[x0]
   add	x0,x0,#8
   b	insert_loop

save:
   str	x1,[x0]

User_input_exit:
   ldr	x0,=tailPtr
   str	x1,[x0]

   ldr	x30,[SP], #16
   ldr	x2,[SP], #16
   ldr	x1,[SP], #16
   ldr	x0,[SP], #16

   RET	LR

   .end
