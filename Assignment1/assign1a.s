//Name: Maad Ahmed Abbasi
//UCID: 30127307
//Course: CPSC355 F22
//Tutorial: T01




.extern printf	

fmt:	.string "x = %d\n"	//String for x value
fmt2:	.string "y = %d\n"	//String for y value
fmt3:	.string	"max = %d\n\n"	//String for max value
.global main
.balign 4
main:	
   	stp	 x29, x30, [sp, -16]!
	mov	 x29, sp

	mov	 x19, -10    //Setting register x19 to the starting x position of -10
	mov	 x20,-40000  //Setting the register x20 to -40000. This register will hold the current maximum value

top:	// Loop Body
	cmp     x19,10      //Comparing the value of register x19 (current x-value) to the max value it can go to (10)
	b.gt exit         // If x19 is greater than 10 the code will exit

	mul     x21,x19,x19 //Constructing x^2 by multiplying the register x19(x) with register x19(x) and storing the result into x21(x^2)
	mul     x21,x21,x19 //Constructing x^3 by multiplying register x21(x^2) with register x19(x) and storing the result back into x21(x^3)
    	mul     x21,x21,x19 //Constructing x^4 by multiplying register x21(x^3) with register x19(x) and storing the result back into x21(x^4)
    	mov     x22,-4       //Setting the register x22 to an immediate value of -4
    	mul     x22,x22,x21  //Constructing -4x^4 by multiplying register x22(-4) by register x21(x^4) and storing the result into x22(-4x^4)

    	mul     x23,x19,x19  //Constructing x^2 by multiplying the register x19(x) with register x19(x) and storing the result into x23(x^2)
    	mov     x24,301     //Setting the register x24 to an immediate value of 301
    	mul     x24,x24,x23 //Constructing 301x^2 by multiplying register x24(301) with register x23(x^2) and storing the result back into register x24(301x^2)

    	add     x22,x22,x24 //Constructing (-4x^4)+(301x^2) by adding register x22(-4x^4) with register x24(301x^2) and storing the result back into register x22(-4x^4+301x^2)

    	mov     x25,56      //Seting the register x25 to an immediate value of 56
    	mul     x25,x25,x19 //Constructing 56x by multiplying register x25(56) with register x19(x)

    	mov     x26,-103    //Setting the register x26 to a constant value of -103

    	add     x25,x25,x26     //Constructing 56x-103 by adding the register x25(56x) with the register x26(-103)

    	add     x22,x22,x25     //Constructing (-4x^4)+(301x^2)+(56x-103) by adding register x22(-4x^4)+(301x^2) with register x25(56x-103)

	ldr	x0, =fmt	//Loads the string for x value
	mov	x1, x19		//Moves value of register x19(x) into register x1
	bl	printf		//prints out the string for x

	ldr	x0,=fmt2	//Loads the string for y value
	mov	x1,x22		//Moves value of register x22(y) into register x1
	bl	printf		//prints out the string for y

	cmp	x22,x20		//Compares register x22(current y value) with register x20(current max value)
	b.lt nochange		//If register x22(current y value) is less than register x20(current max vaue) jump to the label nochange 
	mov	x20,x22		//If register x22(current y value) is greater than register x20(current max value) then move value of register x22 into register x20
	ldr	x0,=fmt3	//Loads the string for max value
	mov	x1,x20		//move value of register x20(max value) into register x1 
	bl	printf		//prints out the string for max value
	b	increment	//jump to increment label

nochange:
	ldr	x0,=fmt3	//Loads the string for max value
	mov	x1,x20		//Moves the value of x20(current max) into register x1
	bl	printf		//prints out the string for max value
	b	increment	//jump to increment label

increment:
	add	x19, x19, 1	//increments the register x19(x value) by 1
	b	top		//jump to the top of the loop



	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret
