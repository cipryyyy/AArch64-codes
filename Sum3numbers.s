//INPUT:

.section __DATA,__data	    //nums section
a: .long 3			//INPUT 1
b: .long 4			//INPUT 2
c: .long 12			//INPUT 3
.cstring                //Const strings section
    fmt: .asciz "%d + %d + %d = "	//FIRST MESSAGE
    out: .asciz "%d\n"			//SECOND MESSAGE

//CODE:

.text      
    .globl      _main			//Where it starts
    .p2align    2			//ALIGN

_main:
    stp     x29, x30, [sp, #-16]!	//IMPORTANT, save datas of LR and FP, otherwise: crash
    mov     x29, sp			//NEW frame (I won't use cause I'm lazy and dumb)
    sub sp, sp, #80			//MOVE BACK
					//80 because 3 vars(24) +1 empty(32) + 3 pages (56) +1 empty (64) + LR,FP (80)
    adrp x8, a@PAGE			//LOAD page of a in x8
    str x8, [sp, #32]			//Save the page
    ldr w8, [x8, a@PAGEOFF]		//ADD the offset in the page and load (32 bit value = w register)
    mov x11, x8				//MOVE in x11

    adrp x8, b@PAGE			//LOAD page of b
    str x8, [sp, #40]			//save the page
    ldr w8, [x8, b@PAGEOFF]		//ADD the offset and load
    mov x10, x8				//MOV in x10

    adrp x8, c@PAGE			//LOAD page of c
    str x8, [sp, #48]			//save the page
    ldr w8, [x8, c@PAGEOFF]		//LOAD page+offset

    mov x9, sp  			//sp in x9 (frame for the printf I guess)
    str x11, [x9]			//STORE input 1
    str x10, [x9, #8]			//STORE input 2
    str x8, [x9, #16]    		//STORE input 3

    adrp x0, fmt@PAGE			//LOAD MESSAGE 1
    add x0, x0, fmt@PAGEOFF

    bl      _printf			//CALL printf

//GET the pages
    ldr x8, [sp, #32]
    ldr x9, [sp, #40]
    ldr x10, [sp, #48]

//LOAD nums
    ldr w8, [x8, a@PAGEOFF]
    ldr w9, [x9, b@PAGEOFF]
    ldr w10, [x10, c@PAGEOFF]

//Add everything
    add w8, w8, w9
    add w8, w8, w10

    mov x9, sp		//SP in x9 again
    str x8, [x9]	//STORE the sum

    adrp x0, out@PAGE			//FINAL MESSAGE
    add x0, x0, out@PAGEOFF		

    bl _printf					//PRINTF

//CLOSING PART
    add sp, sp, #80		//MOVE sp where it was
    mov     w0, #0		//return 0;
    ldp     x29, x30, [sp], #16 //POP the stack
    ret				//give control back
