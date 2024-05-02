/* Programmer: Adam Lenzini
*  String_copy
*  Purpose: Take a string, and copy it into a dynamically allocated string.
*	    Return teh dynamically allocated string.
*  Author: Adam Lenzini
*/

   .global String_copy

   .data

   .text
String_copy:
   stp   x19, x20, [sp, #-16]!   // Push x19 and x20, then move SP down 16 bytes
   stp   x21, x22, [sp, #-16]!   // Push x21 and x22, then move SP down 16 bytes
   stp   x23, x24, [sp, #-16]!   // Push x23 and x24, then move SP down 16 bytes
   stp   x25, x26, [sp, #-16]!   // Push x25 and x26, then move SP down 16 bytes
   stp   x27, x28, [sp, #-16]!   // Push x27 and x28, then move SP down 16 bytes
   stp   x29, x30, [sp, #-16]!   // Push x29 and x30, then move SP down 16 bytes

   mov   x19, x0                 // Move x0 argument into x19
   bl    String_length           // Get length of string argument; store in x0

   add   x0, x0, #1              // Increment string length because of null char
   bl    malloc                  // Create heap allocated chunk
   mov   x25, x0                 // Move pointer result to x25

   cmp   x0, #0                  // If malloc didn't return null,
   bne   copy_char               // Then jump to copy_char loop
   b     return                  // Else jump to return to exit early

copy_char:
   ldrb  w21, [x19], #1          // Load string argument char into w21; increment
   strb  w21, [x0], #1           // Store that char into new heap block; increment
   
   cmp   x21, #0                 // If current char != null,
   bne   copy_char               // Then jump back to top of loop


return:
   mov   x0, x25                 // Move pointer to beginning of heap check into x0

   ldp   x29, x30, [sp], #16     // Pop x29 and x30, then move SP up 16 bytes
   ldp   x27, x28, [sp], #16     // Pop x27 and x28, then move SP up 16 bytes  
   ldp   x25, x26, [sp], #16     // Pop x25 and x26, then move SP up 16 bytes
   ldp   x23, x24, [sp], #16     // Pop x23 and x24, then move SP up 16 bytes
   ldp   x21, x22, [sp], #16     // Pop x21 and x22, then move SP up 16 bytes
   ldp   x19, x20, [sp], #16     // Pop x19 and x20, then move SP up 16 bytes

   RET                           // Return to caller; pointer to new heap chunk in x0

   .end
