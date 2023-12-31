//UCID:30127307
//Teacher: Leonard Manzara
//Lecture: L02
//Tutorial: T01
//Date: Dec 7 2022
//------------------------------------------------------------------------------------- VARIABLES & EQUATES ------------------------------------------------------------------------------------------------

        .data
piover2: .double 0r1.57079632679489661923
upperbound: .double 0r90.0
lowerbound: .double 0r0.0
absvalue: .double 0r1.0e-10


fp .req x29
lr .req x30
buffersize = 8
alloc = -(16 + buffersize) &-16
dealloc = -alloc
bufferstart = 16


define(argc,w19)
define(argv,x20)
define(counter,w21)
define(bufferbase,x22)
define(fd,w23)
define(reader,x24)



//------------------------------------------------------------------------------------ END OF VARIABLES & EQUATES ------------------------------------------------------------------------------------------






//--------------------------------------------------------------------------------------- STRINGS ----------------------------------------------------------------------------------------------------------

        .text
filestart:      .string "FILE START: %s\n "
header:         .string "     x:          |      sin(x)       |   cos(x)  :    \n--------------------------------------------------\n"
xprint:         .string "       %.2f     "
cosprint:       .string "   %.10f   \n "
sinprint:       .string "   %.10f  "
fileend:        .string "\n FILE END\n "
usageerror:     .string "Incorrect number of arguments. \n  usage:./a6 <filename.bin> \n "
filenotfound:	.string "Error: File not found.\n"
//---------------------------------------------------------------------------------------- END OF STRINGS --------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------- START OF MAIN ---------------------------------------------------------------------------------------------------
        .balign 4
        .global main

main:
	stp	fp,lr,[sp,alloc]!	//Allocate space
	mov	fp,sp			//FP = SP
	
	mov	argc,w0			
	mov	argv,x1

	cmp	argc,2			//Compare number of arguments with 2
	b.eq	openfile		//If there are 2 arguments link to openfile
	
	ldr	x0,=usageerror		//If there are not 2 arguments load usageerror to be printed
	bl	printf			//Print string
	b	endmain			//Link to end

	       	

openfile:
	ldr     x0,=filestart   //Load file start to be printed
        ldr     x1,[argv,8]     //Load argv (name of string)  into x1
        bl      printf          //Print string filestart

        mov     w0,-100         //Read input from file
        ldr     x1,[argv,8]     //Load argv (name of string) into x1
        mov     w2,0
        mov     w3,0
        mov     x8,56           //Open at I/O request
        svc     0               //Call system function

        mov     fd,w0           //Move w0 into file descriptor


        cmp     fd,0
        b.ge    continue2               //Print String

        ldr     x0,=filenotfound
        ldr     x1,[argv,8]
        bl      printf

        b       endmain         //Link to end

	
	
continue2:
	ldr	x0,=header 	//Load header string to be printed 
	bl	printf		//Print the string

	add	bufferbase,fp,bufferstart	//Add bufferstart (buffer offset) to fp and store it in bufferbase

open_ok:
	mov	w0,fd				//Set w0 to file descriptor
	mov	x1,bufferbase			//Set x1 to bufferbase
	mov	w2,buffersize			//Set w2 to buffersize
	mov	x8,63				//Set x8 to 63
	svc	0				//Call system function
	
	mov	reader,x0			//Set reader to x0
	
	cmp	reader,buffersize		//Compare reader and buffersize
	b.ne	endoffile			//If redear does not equal buffersize go to endoffile

printx:
	ldr	x0,=xprint			//Load x string for x to be printed
	
	ldr	d0,[bufferbase]			//Load x to be printed
	bl	printf				//Print x
printsine:
	ldr	d0,[bufferbase]			//Load x to be used for sine calculation
	bl	sine				//Link to sine

	ldr	x0,=sinprint			//Load sine string to be printed 
	bl	printf				//Print sine string
	
printcos:	
	ldr	d0,[bufferbase]
	bl	cos

	ldr	x0,=cosprint
	bl	printf

	b	open_ok				//branch to open_ok
endoffile:
        ldr     x0,=fileend			//Load fileend string to be printed 
        bl      printf				//Print string fileend

        mov     w0,fd				//Set w0 to fd
        mov     x8,57				//Set x8 to 57
        svc     0				//Call system function

endmain:
        ldp     fp,lr,[sp],dealloc		//Deallocate space 
        ret					//Return to OS

//------------------------------------------------------------------------------------- END OF MAIN --------------------------------------------------------------------------------------------------------

sine:
	stp	fp,lr,[sp,-16]!	//Allocate memory for sine
	mov	fp,sp		//FP = SP
	
	fmov	d8,d0		//Set input (register d0) to register d8
	

	adrp	x9,piover2
	add	x9,x9,:lo12:piover2
	ldr	d9,[x9] 	//Load value of piover2 (register x9) into register d9
	
	adrp	x10,lowerbound
	add	x10,x10,:lo12:lowerbound
	ldr	d10,[x10]	//Load value of 0 (register x10) into register d10

	adrp	x11,upperbound
	add	x11,x11,:lo12:upperbound
	ldr	d11,[x11]	//Load value of 90 (register x11) into register d11

	adrp	x12,absvalue
	add	x12,x12,:lo12:absvalue
	ldr	d12,[x12]	//Load value of absvalue (register x12) into register d12


	fdiv	d9,d9,d11	//Divide pi/2 by 90 giving you pi/180

	fmul	d8,d8,d9	//Multiply degrees by pi/180 to convert it into radians



	mov	w9,1		//Term number (Increases by 1 each iteration)

	fmov	d15,1.0		//Set n to 1.0 (Increases by 2 each iteration)
	fmov	d9, 1.0
sineloop:
	cmp	w9,1	//Compare first term to 1
	b.gt	sinecontinue	//If first term is greater than 1 then go to sinecontinue

	fmov	d13,d8		//Set first term to x
	b	sineaddterm

sinecontinue:
	fmul	d13,d13,d8	//Multiply current term by x
	fmul	d13,d13,d8 	//Multiply current term by x to get x^2

	fdiv	d13,d13,d15	//Divide current term by n
	fmov	d14,1.0		//Temporarly set d14 to 1.0
	fsub	d15,d15,d14	//Sub 1.0 from n
	fdiv	d13,d13,d15	//Divide current term by n-1
	fadd	d15,d15,d14	//Increment n to its original value 
	
	fneg	d9,d9		//Negate current term
	fmul	d13, d13, d9
sineaddterm:
	fadd	d10,d10,d13	//Add current term to ongoing sum
	add	w9,w9,1		//Increment term number by 1

	fmov	d7,2.0		
	fadd	d15,d15,d7	//Increment n by 2

termpositive:
	adrp	x11,lowerbound
	add	x11,x11,:lo12:lowerbound
	ldr	d11,[x11]


	fcmp	d13,d11
	b.gt	convergencetest
termnegative:
	fneg	d13,d13

convergencetest:
	fcmp	d13,d12		//Comapre current term to absvalue
	b.gt	sineloop

sineend:
	fmov	d0,d10	//Sets d0 to sinx
	ldp	fp,lr,[sp],16	//Deallocate space
	ret		//Return to main



cos:
	stp	fp,lr,[sp,-16]!	//Allocate memory for sine
	mov	fp,sp		//FP = SP
	
	fmov	d8,d0		//Set input (register d0) to register d8
	

	adrp	x9,piover2
	add	x9,x9,:lo12:piover2
	ldr	d9,[x9] 	//Load value of piover2 (register x9) into register d9
	
	adrp	x10,lowerbound
	add	x10,x10,:lo12:lowerbound
	ldr	d10,[x10]	//Load value of 0 (register x10) into register d10

	adrp	x11,upperbound
	add	x11,x11,:lo12:upperbound
	ldr	d11,[x11]	//Load value of 90 (register x11) into register d11

	adrp	x12,absvalue
	add	x12,x12,:lo12:absvalue
	ldr	d12,[x12]	//Load value of absvalue (register x12) into register d12


	fdiv	d9,d9,d11	//Divide pi/2 by 90 giving you pi/180

	fmul	d8,d8,d9	//Multiply degrees by pi/180 to convert it into radians



	mov	w9,1		//Term number (Increases by 1 each iteration)

	fmov	d15,d10		//Set n to 1.0 (Increases by 2 each iteration)
	fmov	d9, 1.0
cosloop:
	cmp	w9,1	//Compare first term to 1
	b.gt	coscontinue	//If first term is greater than 1 then go to coscontinue

	fmov	d13,1.0		//Set first term to 1.0
	b	cosaddterm

coscontinue:
	fmul	d13,d13,d8	//Multiply current term by x
	fmul	d13,d13,d8 	//Multiply current term by x to get x^2

	fdiv	d13,d13,d15	//Divide current term by n
	fmov	d14,1.0		//Temporarly set d14 to 1.0
	fsub	d15,d15,d14	//Sub 1.0 from n
	fdiv	d13,d13,d15	//Divide current term by n-1
	fadd	d15,d15,d14	//Increment n to its original value 
	
	fneg	d9,d9		//Negate current term
	fmul	d13, d13, d9
cosaddterm:
	fadd	d10,d10,d13	//Add current term to ongoing sum
	add	w9,w9,1		//Increment term number by 1

	fmov	d7,2.0		
	fadd	d15,d15,d7	//Increment n by 2

termpositive2:
	adrp	x11,lowerbound
	add	x11,x11,:lo12:lowerbound
	ldr	d11,[x11]


	fcmp	d13,d11
	b.gt	convergencetest2
termnegative2:
	fneg	d13,d13

convergencetest2:
	fcmp	d13,d12		//Comapre current term to absvalue
	b.gt	cosloop

coseend:
	fmov	d0,d10	//Sets d0 to cosx
	ldp	fp,lr,[sp],16	//Deallocate space
	ret		//Return to main










	
