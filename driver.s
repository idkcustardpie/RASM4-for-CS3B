   .equ	NODE_SIZE, 16
   .equ MAX_LEN, 29
   .equ R, 00
   .equ	TC_RW, 01102
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
szChoice5:	.asciz "You chose option 5\n\n"
szChoice6:	.asciz "You chose option 6\n\n"
szInvalid:	.asciz "Please enter a valid option: "
szEntry:	.asciz "Enter a string: "
szDeleteIndex:	.asciz "Which index would you like to delete: "
szEdit:		.asciz "What would you like the new string to be: "
szEditIndex:	.asciz "Which index would you like to edit: "
szFileName:	.asciz "Enter the file name (input.txt) : "
szSaveYes:    	.asciz "FILE SAVED\n"
szSaveError:    .asciz "UNABLE TO SAVE FILE\n"
szEOF:		.asciz "END OF FILE REACHED\n"
szERROR:	.asciz "UNABLE TO OPEN FILE\n"
szCloseBracket:	.asciz "] "
szPar:        	.asciz " \" "
szBracket1:    	.asciz " ("
szMsgHit:    	.asciz " hits in "
szMsgFileOf:    .asciz " files of "
lineCount:    	.quad  0
fileCount:    	.quad  0
hitCount:    	.quad  0    // the amount of hits, +1 for line
fileMaxCount:   .quad  1
szBracket2:    	.asciz " searched)"
szColon:    	.asciz ": "
szLine:        	.asciz "Line "
szSearch:    	.asciz "Search "

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
searchTermPtr:	.quad 0

szBuffer:	.skip 30
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
   cmp	w0,#'5'		// Branch to choice_five if the choice is 4
   beq	choice_five
   cmp	w0,#'6'		// Branch to choice_six if the choice is 4
   beq	choice_six
   cmp	w0,#'7'		// Branch to free_memory if the choice is 7
   beq	free_memory

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

choice_five:
   ldr	x0,=szChoice5	// you chose 5
   bl	putstring

   ldr	x0,=szEntry	// enter string please:
   bl	putstring

   ldr	x0,=szBuffer
   mov	x1,MAX_LEN
   bl	getstring

   ldr	x0,=szBuffer
   bl	String_copy

   ldr	x1,=searchTermPtr
   str	x0,[x1]

   bl	search

   ldr	x0,=searchTermPtr
   ldr	x0,[x0]

   bl	free
   //cmp	x0,#1
   //beq	true

   //bl	print_search
   b	_start			// just in case

choice_six:
   ldr	x0,=szChoice6     // Load address of szChoice6 into x0
   bl	putstring          // Call putstring to print the string

save_file:
   ldr	x0, =dbNodes      // Load address of dbNodes into x0
   ldr	x0, [x0]          // Load value at dbNodes into x0
   cmp	x0, #0            // Compare x0 with 0
   beq	save_error        // Branch if equal to save_error

   ldr	x0, =szFileName    // Load address 
   bl	putstring          // Call putstring to print the prompt

   ldr	x0, =fileBuf      // Load address of fileBuf into x0
   mov	x1, #512          // Load 512 into x1
   bl	getstring          // Call getstring to get input

   mov	x0, #AT_FDCWD     // Load local directory into x0
   mov	x8, #56           // Load Openat command into x8
   ldr	x1, =fileBuf      // Load address of filename into x1

   mov	x2, #TC_RW         // Load C_RW into x2 for file creation
   mov	x3, #0600         // Load permissions into x3
   svc	0                 // service call

   ldr	x1,=iFD           // Load address of iFD into x1
   strb	w0,[x1]          // Store returned file descriptor in iFD

   ldr	x19, =dbNodes     // Load address of dbNodes into x19
   ldr	x19, [x19]        // Load number of nodes into x19
   ldr	x20, =headPtr     // Load address of headPtr into x20
   ldr	x20, [x20]        // Load address of node into x20

save_loop:
   ldr	x0, [x20, #0]    // Load address of string into x0
   bl	String_length      // Call String_length to get string length
   mov	x11, x0           // Move string length into x11
   ldr	x10, [x20, #0]   // Load address of string into x10
   bl	save_string         // Call file_input function

   sub	x19, x19, #1      // Subtract number of nodes
   cmp	x19, #0           // Compare number of nodes with 0
   beq	save_end          // Branch if equal to save_end

   ldr	x20, [x20, #8]   // Load address of next node into x20
   b	save_loop           // Branch to save_loop

save_end:
   ldr	x0, =szSaveYes    // Load address of successful save into x0
   bl	putstring         // Call putstring to print the success message

   ldr	x0,=iFD           // Load address of iFD into x0
   ldrb	w0,[x0]          // Load byte at address of iFD into w0
   mov	x8, #57           // Load exit code into x8
   svc	0                 // System call

   b	_start              // branch to _start

free_memory:
   ldr	x1,=headPtr	// load headPtr to x1
   ldr	x1,[x1]		// load the node pointed to by headPtr to x1

free_loop:
   ldr	x2,[x1]		// load HEAD->DATA to x2
   ldr	x3,[x1,#8]	// load HEAD->NEXT to x3
   mov	x0,x2		// copy x2 to x0
   str	x3,[SP,#-16]!
   str	x1,[SP,#-16]!
   bl	free		// free HEAD->DATA

   ldr	x1,[SP],#16
   mov	x0,x1		// copy x1 to x0
   bl	free		// free the node

   ldr	x3,[SP],#16
   mov	x1,x3		// copy x3 to x1 (Now on node pointed to by NEXT)
   cmp	x1,#0		// check if node is empty
   beq	exit		// branch to exit if true

   b	free_loop	// branch to top of free_loop

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

   ldr	x1,=newNodePtr	// load the address of newNodePtr to x1
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
   ldr	x21,[x21]
   cmp	x20,x21
   beq	find_previous

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

find_previous:
   ldr	x19,[x19]
   ldr	x20,=currentPtr
   str	x19,[x20]
   add	x19,x19,#8
   ldr	x20,[x19]
   cmp	x20,#0
   beq	move_tail

   ldr	x20,=currentPtr
   ldr	x20,[x20]
   ldr	x21,=previousPtr
   str	x20,[x21]

   //ldr	x19,[x19]
   //ldr	x19,[x19]
   //add	x21,x21,#1
   b	find_previous

move_tail:
   //ldr	x0,=tailPtr
   //ldr	x1,[x0]
   //add	x1,x1,#8

   ldr	x19,=currentPtr
   ldr	x19,[x19]
   ldr	x0,[x19]
   bl	String_length
   ldr	x20,=dbByte
   ldr	x21,[x20]
   sub	x21,x21,x0
   sub	x21,x21,#16
   str	x21,[x20]

   ldr	x20,=dbNodes
   ldr	x21,[x20]
   sub	x21,x21,#1
   str	x21,[x20]

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

search:
   str	x30,[SP,#-16]!
   ldr	x0,=searchTermPtr
   ldr	x0,[x0]
   mov	x1,#0						// initialize with 0
   //add	x0,x0,#6					// set x0 to 6
   //add	x1,x1,#6					// x1 to 6 as well
   ldr	x2,=headPtr

// Displaying all strings even when they do not contain the search term!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!
search_loop_1:
   ldr	x2,[x2]
   cmp	x2,#0
   beq	end_search

   ldr	x3,[x2]

   search_loop_2:
      ldrb	w4,[x3]
      cmp	w4,#0
      beq	line_end

      //search_loop_3:
      ldrb	w5,[x0]
      cmp	w5,#0
      beq	match_found
      cmp	w4,w5
      beq	increment_search

      sub	w5,w5,#32
      cmp	w4,w5
      beq	increment_search

      ldr	x0,=searchTermPtr
      ldr	x0,[x0]

      b		increment_line

   increment_search:
      add	x0,x0,#1

   increment_line:
      add	x3,x3,#1
      b		search_loop_2

match_found:
   str	x0,[SP,#-16]!
   str	x2,[SP,#-16]!
   str	x1,[SP,#-16]!

   ldr  x0,=chOpenBracket       // Print the open bracket character to screen
   bl   putch

   //mov  x0,x1          // copy the value in x20 to x0
   ldr	x0,[SP],#16
   str	x0,[SP,#-16]!
   ldr  x1,=szBuffer    // convert x0 from int 64 to ascii
   bl   int64asc

   ldr  x0,=szBuffer    // print which node we are on
   bl   putstring

   ldr  x0,=szCloseBracket      // print the close brackets
   bl   putstring

   ldr	x1,[SP],#16
   ldr	x2,[SP],#16
   ldr	x0,[x2]
   str	x2,[SP,#-16]!
   str	x1,[SP,#-16]!
   bl	putstring

   ldr	x1,[SP],#16
   ldr	x2,[SP],#16
   ldr	x0,[SP],#16

line_end:
   //ldr	x2,[x2,#8]
   add	x2,x2,#8
   add	x1,x1,#1
   ldr	x0,=searchTermPtr
   ldr	x0,[x0]
   b	search_loop_1

end_search:
   ldr	x30,[SP],#16
   RET	LR

/*search_last:
   // loading our string's byte in
   ldrb  w2, [x0]           	// Load the next byte of the string into w2 and increment the address
   // loading our next string's byte in
   //ldrb  w3, [x1]

   cmp   w2,w3               	// Compare the string if they match first round in

   b.ne  search_last_2  		// If they don't match, continue searching

   b     end_search       		// Else, end search for that current string

// this checks if it is the end of the string
search_last_2:
   cmp   w2, #0                 			// Check if we've reached the end of the string (null terminator)
   sub	x1,x1,#1				// subtract index
   sub	x0,x0,#1				// subtract address
   b.ne  search_last       			// If not, continue searching
   mov	x1,#-1					// x1 to -1 value

end_search:
   RET	LR					// return

// this prints a line that is true to search
print_search_line:

   ldr	x0,=szLine	// "Line "
   bl	putstring
   ldr	x0,=lineCount
   ldr	x0,[x0]

   ldr	x1,=szBuffer
   bl	int64asc
   ldr	x0,=szBuffer
   bl	putstring

   ldr	x0,=szColon	// ": "
   bl	putstring

   // print the line here

   ldr	x0,=chLF
   bl	putch

   // check if that is ALL of the true strings
   b	_start					// return to the address stored in the link register

// formatting
print_search:
   ldr	x0,=szSearch	// Search
   bl	putstring
   ldr	x0,=szPar1
   bl	putstring
   ldr	x0,=szBuffer	// the string to search
   bl	putstring
   ldr	x0,=szPar2
   bl	putstring
   //  (# hits in # file of # searched)
   ldr	x0,=szBracket1
   bl	putstring
   ldr	x0,=hitCount
   ldr	x0,[x0]
   ldr	x1,=szBuffer
   bl	int64asc
   ldr	x0,=szBuffer
   bl	putstring
   ldr	x0,=szMsgHit
   bl	putstring
   ldr	x0,=fileCount
   ldr	x0,[x0]
   ldr	x1,=szBuffer
   bl	int64asc
   ldr	x0,=szBuffer
   bl	putstring
   ldr	x0,=szMsgFileOf
   bl	putstring
   ldr	x0,=fileMaxCount
   ldr	x0,[x0]
   ldr	x1,=szBuffer
   bl	int64asc
   ldr	x0,=szBuffer
   bl	putstring
   ldr	x0,=szBracket2
   bl	putstring
   ldr	x0,=chLF
   bl	putch

   //cmp	x9,x0		  // is there a line to print?
   b	_start		  // if not, return to start*/

save_string:
   str	x19, [SP, #-16]!
   str	x20, [SP, #-16]!
   str	x21, [SP, #-16]!
   str	x22, [SP, #-16]!
   str	x23, [SP, #-16]!
   str	x24, [SP, #-16]!
   str	x25, [SP, #-16]!
   str	x26, [SP, #-16]!
   str	x27, [SP, #-16]!
   str	x28, [SP, #-16]!
   str	x29, [SP, #-16]!
   str	x30, [SP, #-16]!
   mov	x29, SP

   mov	x0, #AT_FDCWD
   mov	x8, #56
   ldr	x1, =fileBuf

   mov	x2, #02002
   mov	x3, #0600
   svc	0

   mov	x8, #64
   mov	x1, x10
   mov	x2, x11
   svc	0

   mov    x0, #0x0a     // ASCII code for new line character
   mov    x8, #64       // syscall number for write
   mov    x2, #1        // length of the string (1 for new line)
   svc    0

   // Open 
   /* mov	x0, #AT_FDCWD		// local directory
   mov	x8, #56 		// Openat
   ldr	x1, =fileBuf
   // Create 
   mov	x2, #02002		// Create 
   mov	x3, #0600		// permissions
   svc	0			// service call */

   // make a new line here!


   // restoring preserved registers x19-x30 (AAPACS)
   ldr	x30, [SP], #16
   ldr	x29, [SP], #16
   ldr	x28, [SP], #16
   ldr	x27, [SP], #16
   ldr	x26, [SP], #16
   ldr	x25, [SP], #16
   ldr	x24, [SP], #16
   ldr	x23, [SP], #16
   ldr	x22, [SP], #16
   ldr	x21, [SP], #16
   ldr	x20, [SP], #16
   ldr	x19, [SP], #16	

   // return
   RET


save_error:
   ldr	x0, =szSaveError  // Load address save error into x0
   bl	putstring          // Call putstring to print message
   b	_start              // branch to _start

   .end
