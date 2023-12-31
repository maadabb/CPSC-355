//Name: Maad Ahmed Abbasi
//UCID: 30127307
//Course: CPSC355 F22
//Tutorial: T01
//Description: Takes a hexadecimal and reverses it using bitwise logical operators such as and, or ,logical shift left and logical shift right then prints original and reversed hex values to screen.
//Date: October 7 2022
//File Name: assign2c.asm
define(x_var, w19)
define(y_var, w20)
define(t1, w21)
define(t2, w22)
define(t3, w23)
define(t4, w24)



.extern printf

fmt:    .string "original: 0x%08X reversed: 0x%08X\n"

        .global main
        .balign 4

main:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp




        mov     x_var,0x01FF01FF  //Initialize x value as 0x01FF01FF


step1:
        and     t1,x_var,0x55555555     //Using the and operation with x (register 19) and immediate value 0x55555555 then storing the result into t1 (register w21)            
        lsl     t1,t1,1        //Using the logical shift left operator on t1 (register w21) to multiply by a factor of 2^1 or shift 1 unit left then storing result back into t1 (register w21)

        lsr     t2,x_var,1           //Using Logical shift right operator on x (register w19) to divide by a factor of 2^1 or shift 1 unit right then storing result into t2 (register w22)
        and     t2,t2,0x55555555      //Using the and operation with register t2 (register w22) and immediate value 0x55555555 then storing result back into t2 (register w22)

        orr     y_var,t1,t2     //Using or operation on t1 register(w21) and t2 (register w22) and storing result into y (register w20)

step2:
        and     t1,y_var,0x33333333 //Using the and operation with y (register 20) and immediate value 0x33333333 then storing the result into t1 (register w21)
        lsl     t1,t1,2        //Using the logical shift left operator on t1 (register w21) to multiply by a factor of 2^2 or shift 2 units left then storing result back into t1 (register w21)

        lsr     t2,y_var,2        //Using Logical shift right operator on y (register w20) to divide by a factor of 2^2 or shift 2 units right then storing result into t2 (register w22)
        and     t2,t2,0x33333333 //Using the and operation with register t2 (register w22) and immediate value 0x333333333 then storing result back into t2 (register w22)

        orr     y_var,t1,t2 //Using or operation on t1 register(w21) and t2 (register w22) and storing result into y (register w20)



step3:

        and     t1,y_var,0x0F0F0F0F //Using the and operation with y (register 20) and immediate value 0x0F0F0F0F then storing the result into t1 (register w21)
        lsl     t1,t1,4       //Using the logical shift left operator on t1 (register w21) to multiply by a factor of 2^4 or shift 4 units left then storing result back into t1 (register w21)

        lsr     t2,y_var,4 //Using Logical shift right operator on y (register w20) to divide by a factor of 2^4 or shift 4 units right then storing result into t2 (register w22)
        and     t2,t2,0x0F0F0F0F  //Using the and operation with register t2 (register w22) and immediate value 0x0F0F0F0F then storing result back into t2 (register w22)

        orr     y_var,t1,t2             //Using or operation on t1 register(w21) and t2 (register w22) and storing result into y (register w20)


step4:
        lsl     t1,y_var,24      //Using logical shift left operator on y (register w20) to multiply by a factor of 2^24 or shift 24 unita left then storing the result into t1 (register w21)

        and     t2,y_var,0xFF00  //Using and operation on y (register w20) with the immediate value of 0xF00 then storing the result into t2 (register w22)
        lsl     t2,t2,8       //Using logical shift left operator on t2 (register w22) to multiply by a factor of 2^8 or shift 8 units left then storing the result into t2 (register w22) 

        lsr     t3,y_var,8      //Using logical shift right operator on y (register w20) to divide by a factor of 2^8 or shift 8 units right then storing the result into t3
        and     t3,t3,0xFF00 //Using and operation on t3 (register w23) with the immediate value of 0xFF00 then storing the result into t3 (register w23)

        lsr     t4,y_var,24 //Using logical shift right operator on y (register w20) to divide by a factor of 2^24 or shift 24 units right then storing the result into t4

        orr     y_var,t1,t2 //Using the or operation on t1 (register w21) and t2 (register w22) then storing the result into y (register w20)
	orr     y_var,y_var,t3  //Using the or operation on y (register w20) and t3 (register w23) then storing the result into y (register w20)
        orr     y_var,y_var,t4 //Using the or operation on y (register w20) and t4 (register w24) then storing the result into y (register w20)

	ldr     w0,=fmt  //Loading string fmt
       	mov     w1,x_var //Storing value of x (register w19) which is original number into the first value of string register w1
       	mov     w2,y_var //Storing value of y (register w20) which is reversed number into the second value of string register w2
       	bl      printf   //Printing the string



exit:
        mov     x0, 0
        ldp     x29, x30, [sp], 16
        ret


