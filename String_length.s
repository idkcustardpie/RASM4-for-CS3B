 .global String_length

   .text
String_length:
   mov	x2, #0	// copy 0 into x2

length_loop:
   ldrb	w1,[x0]		// load a byte of x0 into w1
   cmp	w1, #0		// compare w1 to 0/0x00
   beq	end_length	// branch to end_length if equal
   add	x0, x0, #1	// add 1 to x0 and store in x0
   add	x2, x2, #1	// add 1 to x2 and store in x2
   b	length_loop	// branch back to length_loop

end_length:
   mov	x0, x2	// copy x2 to x0

   RET	LR	// Return to the address contained in the link register

   .end
