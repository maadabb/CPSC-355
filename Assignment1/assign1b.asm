//Name: Maad Ahmed Abbasi    	
//UCID : 30127307
//Course: CPSC355 F22
//Tutorial: T01


define(x_value,x19)	//Defining register x19 as x_value(this register will be used to hold the current x value)
define(current_max_value,x20)	//Defining register x20 as current_max_value(this register will be used to hold the current max)
define(terms,x21)	//Defining register x21 as terms(this will be used to store terms)
define(constant,x22)	//Defining register x22 as constant (This will be used to store a constant value)
define(myfunction,x23)	//Defining register x23 as polynomial (this will store the polynomial)
fmt:    .string "x = %d\n"
fmt2:   .string "y = %d\n"
fmt3:   .string "max = %d\n\n"
.global main
.balign 4
   
main:
        stp      x29, x30, [sp, -16]!
        mov      x29, sp
        mov      x_value, -10    //Setting register x19 to the starting x position of -10
        mov      current_max_value,-40000  //Setting the register x20 to -40000. This register will hold the current maximum value
	b	looptest	//jump to label looptest
top:    // Loop Body
        mul     terms,x_value,x_value //Constructing x^2 by multiplying x_value(register x19) with x_value(register x19) and storing the result in terms(register x21)
        mul     terms,terms,x_value //Constructing x^3 by multiplying temr with x_value and storing the result back into terms
        mul     terms,terms,x_value //Constructing x^4 by multiplying terms with x_value and storing the result into terms
        mov     constant,-4       //Setting constant to an immediate value of -4
        mul     terms,terms,constant  //Constructing -4x^4 by multiplying terms with constsnt snd storing the reuslt into terms
        mov     myfunction,terms	//moving value of terms into myfunction

        mul     terms,x_value,x_value  //Constructing x^2 by multiplying 
        mov     constant,301     //Setting constant to an immediate value of 301
        
        madd    myfunction,terms,constant,myfunction //Using madd function to multiply constant with terms and add  myfunction to it. Result is then stored in myfunction

        mov     constant,56      //Setting constant to an immediate value of 56
        
        madd    myfunction,constant,x_value,myfunction	//Using madd function to multiply x_value with constant and add my function to it. Result is then stored in myfunction

        add     myfunction,myfunction,-103  //Using add to add constant of -103 to myfunction and storing result back into myfunction

        ldr     x0, =fmt	//Loads the string for x value
        mov     x1, x_value	//mov value of x_value into register x1
        bl      printf		//print the value of x_value

        ldr     x0,=fmt2	//Loads the string for y value
        mov     x1,myfunction	//mov value of myfunction into register x1
        bl      printf		//print the value of myfunction 

        cmp     myfunction,current_max_value	//compares the value of myfunction with the value of the current_max_value
        b.lt nochange				//checks if myfunction is less than current_max_value. If true then jump to label nochange
        mov     current_max_value,myfunction	//moves the value of myfunction into current_max_value
        ldr     x0,=fmt3			//loads the string for max value
        mov     x1,current_max_value		//moves the value of current_max_value into register x1
        bl      printf				//prints the value of current_max_value
        b       increment			//jump to label increment

nochange:
        ldr     x0,=fmt3			//Loads the string for max value
        mov     x1,current_max_value		//moves the value of current_max_value into the register x1
        bl      printf				//prints the value of current_max_value
        b       increment			//jump to label increment

increment:
        add     x_value, x_value, 1		//Add the immediate value of 1 to x_value
        b       looptest			//jump to looptest
looptest:
        cmp     x_value,10      //Comparing the value of x_value to the immediate value of 10
        b.le  top		// If x_value is less than or equal to 10 jump to top of loop
	         
exit:   mov     x0, 0
        ldp     x29, x30, [sp], 16
        ret
                   
