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
previousPtr:	.quad 0

szBuffer:	.skip 21
fileBuf:	.skip 512

   .text
_start:
   ldr	x0,=szTitle	// display the title of the program
   bl	putstring

   ldr	x0,=szDataHeap	// display the about of memory used by the program
   bl	putstring

   ldr	x0,=dbByte	// load the number of bytes used to x0
   ldr	x0,[x0]

   ldr	x1,=szBuffer	// convert the int to ascii characters
   bl	int64asc

   ldr	x0,=szBuffer	// print the bytes to screen
   bl	putstring

   ldr	x0,=szBytes	// print the word "bytes"
   bl	putstring

   ldr	x0,=szNumNodes	// display the number of nodes in the linked list
   bl	putstring

   ldr	x0,=dbNodes	// load the number of nodes to x0
   ldr	x0,[x0]

   ldr	x1,=szBuffer	// convert the int to ascii characters
   bl	int64asc

   ldr	x0,=szBuffer	// print the nodes to screen
   bl	putstring

   ldr	x0,=szOptions1	// print the first part of the options menu
   bl	putstring

   ldr	x0,=szOptions2	// print the second part of the options menu
   bl	putstring

   ldr	x0,=szOptions3	// print the third part of the options menu
   bl	putstring

   ldr	x0,=szInput	// print the prompt for the user to pick an option
   bl	putstring

enter:
   ldr	x0,=szBuffer	// receive the choice from the user
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer	// Compare the input to branch to the correct option
   ldrb	w0,[x0]
   //ldr	x1,=chChoice
   //strb	w0,[x1]

   //ldr	x0,=chChoice
   //ldr	x0,[x0]
   cmp	w0,#'1'		// Branch to choice_one if the choice is 1
   beq	choice_one
   cmp	w0,#'2'		// Branch to choice_two if the choice is 2
   beq	choice_two
   cmp	w0,#'3'		// Branch to choice_three if the choice is 3
   beq	choice_three
   cmp	w0,#'4'		// Branch to choice_four if the choice is 4
   beq	choice_four
   cmp	w0,#'7'		// Branch to exit if the choice is 7
   beq	exit

   ldr	x0,=szInvalid	// Print the message that the input was invalid if not any of these choices
   bl	putstring

   b	enter		// branch back to enter

choice_one:
   ldr	x0,=szChoice1	// print the message that first choice selected
   bl	putstring

   bl	traverse	// branch and link to traverse

   b	_start		// branch back to the beginning

choice_two:
   //ldr	x0,=szChoice2
   //bl	putstring
   ldr	x0,=szBuffer	// receive the subchoice for choice 2
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer	// Compare the input to branch to the correct option
   ldrb	w0,[x0]

   cmp	w0, #'a'	// Branch to choice_two_a if the choice is a
   beq	choice_two_a

   cmp	w0, #'b'	// Branch to choice_two_b if the choice is b
   beq	choice_two_b

   ldr	x0,=szInvalid	// Print the message that the input was invalid if not any of these choices
   bl	putstring

   b	choice_two	// branch back to beginning of choice_two

choice_two_a:
   ldr	x0,=szChoice2a	// print the message that choice 2a was selected
   bl	putstring

   bl	user_insert	// branch and link to user_insert

   b	_start		// branch back to the beginning

choice_two_b:
   ldr	x0,=szChoice2b	// print the message that choice 2b was selected
   bl	putstring

   bl	file_input	// branch and link to file_input

   b	_start		// branch back to the beginning

choice_three:
   ldr	x0,=szChoice3		// print the message that third choice selected
   bl	putstring

   ldr	x0,=szDeleteIndex	// print the prompt to ask which string to delete
   bl	putstring

   ldr	x0,=szBuffer		// receive input from user
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer		// convert the input from ascii to a 64 bit integer
   bl	ascint64

   bl	delete			// branch and link to delete

   b	_start			// branch back to start

choice_four:
   ldr	x0,=szChoice4	// print the message that fourth choice selected
   bl	putstring

   ldr	x0,=szEditIndex	// print the prompt to ask which string to edit
   bl	putstring

   ldr	x0,=szBuffer	// receive input from user
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer	// convert the input from ascii to a 64 bit integer
   bl	ascint64

   bl	edit		// branch and link to edit

   b	_start		// branch back to start

exit:
   /**** EXIT SEQUENCE ****/
   mov	x0,#0		// Use 0 return code
   mov	x8, #93		// Service code 93 terminates the program
   svc	0		// Call Linux to terminate the program

traverse:
   str	x0,[SP,#-16]!	// push x0 onto the stack
   str	x1,[SP,#-16]!	// push x1 onto the stack
   str	x19,[SP,#-16]!	// push x19 onto the stack
   str	x20,[SP,#-16]!	// push x20 onto the stack
   str	x30,[SP,#-16]!	// push x30 onto the stack

   ldr	x19,=headPtr	// load the address of headPtr to x19
   mov	x20,#0		// copy 0 into x20 to act as the counter

traverse_top:
   ldr	x19,[x19]	// load the address of the node pointed to by headPtr

   cmp	x19,#0		// compare to see if the node is empty
   beq	traverse_exit	// branch to traverse_exit if true

   //str	x19,[SP,#-16]!
   //str	x20,[SP,#-16]!

   ldr	x0,=chOpenBracket	// Print the open bracket character to screen
   bl	putch

   //ldr	x20,[SP], #16

   mov	x0,x20		// copy the value in x20 to x0
   ldr	x1,=szBuffer	// convert x0 from int 64 to ascii
   bl	int64asc

   ldr	x0,=szBuffer	// print which node we are on
   bl	putstring

   ldr	x0,=szCloseBracket	// print the close brackets
   bl	putstring

   ldr	x0,[x19]	// print the string stored in the node to x0
   bl	putstring

   // Causes extra lines for file. Find way to add \n to user strings
   //ldr	x0,=chLF
   //bl	putch

   add	x20,x20,#1	// increment the counter in x20 by one
   add	x19,x19,#8	// increment the address in x19 so it points to *next
   b	traverse_top	// branch back to traverse_top

traverse_exit:
   ldr	x30,[SP], #16	// pop x30 off the stack
   ldr	x20,[SP], #16	// pop x20 off the stack
   ldr	x19,[SP], #16	// pop x19 off the stack
   ldr	x1,[SP], #16	// pop x1 off the stack
   ldr	x0,[SP], #16	// pop x0 off the stack

   RET	LR		// return to the address contained in the link register

user_insert:
   str	x0,[SP, #-16]!	// push x0 onto the stack
   str	x1,[SP, #-16]!	// push x1 onto the stack
   str	x2,[SP, #-16]!	// push x2 onto the stack
   str	x30,[SP, #-16]!	// push x30 onto the stack

   mov	x0,NODE_SIZE	// allocate a block of memory of NODE_SIZE bytes
   bl	malloc

   ldr	x1,=newNodePtr	// store the address of the allocated memory in newNodePtr
   str	x0,[x1]

   ldr	x0,=szEntry	// Print the prompt to enter a new string
   bl	putstring

   ldr	x0,=szBuffer	// receive the new string from the user
   mov	x1,MAX_LEN

   bl	getstring

   ldr	x0,=szBuffer	// get the length of the string
   //bl	String_copy
   bl	String_length
   add	x0,x0,#1	// add one to the length

   bl	malloc		// allocate a block of memory for the string + \n

   ldr	x1,=newNodePtr	// load newNodePtr to x1
   ldr	x1,[x1]		// load the address pointed to by newNodePtr to x1
   //ldr	x1,[x1]

   str	x0,[x1]		// store the allocated string memory to the node

   ldr	x1,=newNodePtr	// load the address of newNodePtr
   ldr	x1,[x1]		// load the address of the node pointed to by newNodePtr
   ldr	x1,[x1]		// load the address of the allocated string memory

   ldr	x0,=szBuffer	// load szBuffer with the user string in it to x0

copy_loop:
   ldrb	w2,[x0]		// load a byte of szBuffer to w2
   cmp	w2,#0		// compare w2 to 0 to see if its a null character
   beq	end_copy	// branch to end_copy if true

   strb	w2,[x1]		// store a byte from w2 to x1

   add	x0,x0,#1	// increment x0 by 1
   add	x1,x1,#1	// increment x1 by 1

   b	copy_loop	// branch back to top of copy_loop

end_copy:
   ldr	x0,=chLF	// load address of chLF to x0
   ldrb	w2,[x0]		// load a byte from x0 to w2
   strb	w2,[x1]		// store the line feed character from w2 to x1

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

file_input:
   /*str	x0,[SP,#-16]!
   str	x1,[SP,#-16]!
   str	x2,[SP,#-16]!
   str	x3,[SP,#-16]!
   str	x4,[SP,#-16]!*/
   //str	x8,[SP,#-16]!
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
   str	x0,[SP,#-16]!
   str	x1,[SP,#-16]!
   str	x2,[SP,#-16]!
   str	x3,[SP,#-16]!
   str	x4,[SP,#-16]!

   mov	x0,NODE_SIZE	// allocate memory block of NODE_SIZE bytes
   bl	malloc

   ldr	x1,=newNodePtr	// store the address of the memory in newNodePtr
   str	x0,[x1]

   ldr	x4,[SP], #16
   ldr	x3,[SP], #16
   ldr	x2,[SP], #16
   ldr	x1,[SP], #16
   ldr	x0,[SP], #16

   ldr	x1,=fileBuf	//

   bl	getline
   cmp	x0,#0x0
   beq	file_last

   ldr	x0,=fileBuf
   bl	String_copy

   //bl	putstring

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
   //ldr	x8,[SP], #16
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

// Redo this so that it keeps track of previous node
free_tail:
   //str	x19,[SP,#-16]!
   //str	x20,[SP,#-16]!

   /*ldr	x0,=tailPtr
   ldr	x1,[x0]
   ldr	x0,[x1]
   bl	free*/

   //mov	x0,x1
   //bl	free

   /* increment to node before what tailPtr was
      and assign that node ot tailPt*/
   //ldr	x19,[x19]
   //ldr	x20,[SP],#16
   //ldr	x19,[SP],#16
   //sub	x20,x20,#2
   //mov	x21,#0
   //ldr	x19,[x19]

find_previous:
   ldr	x19,[x19]
   ldr	x20,=currentPtr
   str	x19,[x20]
   add	x19,x19,#8
   cmp	x19,#0
   beq	move_tail

   ldr	x20,=currentPtr
   ldr	x20,[x20]
   ldr	x21,=previousPtr
   str	x19,[x20]

   //ldr	x19,[x19]
   //ldr	x19,[x19]
   //add	x21,x21,#1
   b	find_previous

move_tail:
   //ldr	x0,=tailPtr
   //ldr	x1,[x0]
   //add	x1,x1,#8

   ldr	x19,=currentPtr
   ldr	x0,[x19]
   bl	free

   mov	x0,x19
   bl	free

   ldr	x20,=previousPtr
   ldr	x20,[x20]
   ldr	x21,=tailPtr
   //ldr	x19,[x19]
   str	x20,[x21]

   ldr	x0,=tailPtr
   ldr	x0,[x0]
   add	x0,x0,#8
   mov	x19,#0
   str	x19,[x0]

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
