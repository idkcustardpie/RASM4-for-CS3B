/* Programmer: Adam Lenzini
*  String_copy
*  Purpose: Take a string, and copy it into a dynamically allocated string.
*	    Return teh dynamically allocated string.
*  Author: Adam Lenzini
*/

   .global String_copy

   .data
ptrCopy:	.quad 0	// pointer to contain the dynamically allocated string

   .text
String_copy:
   str	x30,[SP, #-16]!	// push x30 onto the stack
   str	x0,[SP, #-16]!	// push x0 onto the stack

   bl	String_length	// branch and link to String_length

   bl	malloc		// branch and link to malloc

   ldr	x1,=ptrCopy	// load the address of ptrCopy to x1
   str	x0,[x1]		// store the memory from malloc into ptrCopy

   ldr	x0,[SP], #16	// pop x0 off the stack
   ldr	x30,[SP], #16	// pop x30 off the stack

   ldr	x1,=ptrCopy	// load address of ptrCopy to x1
   ldr	x1,[x1]		// load the address pointed to by ptrCopy to x1

copy_loop:
   ldrb	w2,[x0]		// load a byte of x0 to w2
   cmp	w2, #0		// compare w2 to #0/0x00
   beq	end_copy	// branch to end_copy if w2 is equal to 0

   strb	w2,[x1]		// store a byte from w2 into x1

   add	x0,x0,#1	// add 1 to x0 and store in x0
   add	x1,x1,#1	// add 1 to x1 and store in x1

   b	copy_loop	// branch back to copy_loop

end_copy:
   ldr	x0,=ptrCopy	// load the address of ptrCopy to x0
   ldr	x0,[x0]		// load the address pointed to by ptrCopy to x0

   RET	LR		// return to the address in the link register
   .end
