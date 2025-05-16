.cstring                                //COSNT STRING SECT
        msg: .asciz "Hello world!\n"    //message
.text                                   //CODE SECTION
        .globl _main                    //starting point
_main:
        stp x29, x30, [sp, #-16]!       //Save FP and LR in the stack
        mov x29, sp                     //Create a new frame

        adrp x0, msg@PAGE               //LOAD in x0 the page
        add x0, x0, msg@PAGEOFF         //Add the offset

        bl _printf                      //CALL _printf function

        mov x0, #0                      //Basically, return 0 of the C
        ldp x29, x30, [sp], #16         //POP the stack
        ret                             //Give the control back
