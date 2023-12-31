//NAME:MAAD AHMED ABBASI
//UCID:30127307
//Teacher: Leonard Manzara
//Lecture: L02
//Tutorial: T01
//Date: Nov 4 2022








//==================================================================================  PRINT STATEMENTS ======================================================================================================================================
printCube: .string "Cuboid %s origin = (%d, %d)\n  \tBase width = %d  Base length = %d\n  \tHeight = %d\n \tVolume = %d\n\n" 

initialCuboid: .string "Initial cuboid values:\n"

changedCuboid: .string "\nChanged cuboid values:\n"

printFirst:.string "first\n"

printSecond:.string "second\n"


//==================================================================================== END PRINT STATEMENTS =================================================================================================================================


//==================================================================================== DEFINE AND LOCAL VARS ================================================================================================================================
fp .req x29
lr .req x30

True = 1
False = 0

pointx = 0
pointy = 4

dimwidth =0
dimlength =4 

pointorigin = 0 //takes up 8  bytes
dimbase = 8 //takes up 8 bytes
cubheight = 16
cubvolume = 20


firstsize  = 24
secondsize= 24
first =16
second =40
alloc = -(16+firstsize+secondsize)&-16
dealloc = -alloc


equalsalloc = -(16+4)&-16
equalsdealloc = -equalsalloc
result = 16

define(firstbase,x20)
define(secondbase,x21)
//==================================================================================== END DEFINE AND LOCAL VARS ============================================================================================================================
//==================================================================================== NEW CUBOID ===========================================================================================================================================
	.global main
	.balign 4
newCuboid:
	stp	fp,lr,[sp,-16]! //Allocate space
	mov	fp,sp //Set fp to sp
	
	mov	w23,0 //set w23 to 0
	
	str	w23,[x8,pointorigin+pointx] //Store 0 to the stack (c.origin.x=0)
	str	w23,[x8,pointorigin+pointy] //Store 0 to the stack (c.origin.y=0)

	mov	w23,2 //Set w23 to 2

	str	w23,[x8,dimbase+dimwidth] //Store 2 to the stack (c.base.width =2)
	str	w23,[x8,dimbase+dimlength]//Store 2 to the stack (c.base.width = 2)

	mov	w23,3 // Set 23 to 3

	str	w23,[x8,cubheight]// Store 3 to the stack (c.height =3 )
	

	ldr	w24,[x8,dimbase+dimwidth] //Load in value of width to w24
	ldr	w25,[x8,dimbase+dimlength] // Load in value of length to w25
	ldr	w26,[x8,cubheight] //Load in value of height to w26
	
	mul	w27,w24,w25 //multiply width (w24) by length (w25) and store it in w27
	mul	w27,w27,w26 //multiply w27 by height (w26) to get  volume
	str	w27,[x8,cubvolume] // Store calculated value of volume to the stack

	ldp	fp,lr,[sp],16 //Deallacote space
	ret //Return to main


//========================================================================= END OF NEW CUBOID ================================================================================================================================================

//========================================================================= START OF MOVE ====================================================================================================================================================

move:
        stp     fp,lr,[sp,-16]! //Allocate 16 bytes of space
        mov     fp,sp //Move fp  to sp

        ldr     w20,[x1,pointorigin+pointx] //Load origin.x into register w20 (c->origin.x)
        add     w20,w20,w2 //Add deltaX to origin.x
        str     w20,[x1,pointorigin+pointx] //Store value of w20 to stack (c->origin.x+=deltaX)

        ldr     w20,[x1,pointorigin+pointy] //Load origin.y into register w21 (c->origin.y)
        add     w20,w20,w3 //Add deltaY to origin.y
        str     w20,[x1,pointorigin+pointy]//Store value of w20 to stack (c->origin.y)

        ldp     fp,lr,[sp],16 //Deallocate space
        ret //Return to main

scale:
        stp     fp,lr,[sp,-16]! //Allocate 16 bytes of space
        mov     fp,sp //Move fp to sp

        ldr     w20,[x1,dimbase+dimwidth] //Load value of width into register w20 (c->base.width)
        mul     w20,w20,w2 //multiply value of width by w1
        str     w20,[x1,dimbase+dimwidth]//Store value of w20 to the stack (c->base.width=*factor)

        ldr     w21,[x1,dimbase+dimlength] //Load value of length into register w21 (c->base.length)
        mul     w21,w21,w2//Mutliply the value of length by w1
        str     w21,[x1,dimbase+dimlength]//Store value of w21 to the stack (c->base.length=*factor)

        ldr     w22,[x1,cubheight]//Load value of height into register w22 (c->height)
        mul     w22,w22,w2//Multiply value of height by w1
        str     w22,[x1,cubheight]//Store value of w22 to the stack (c->height=*factor)

        ldr     w23,[x1,dimbase+dimwidth] //Load value of width into w23
        ldr     w24,[x1,dimbase+dimlength] //Load value of length into w24
        ldr     w25,[x1,cubheight] //Load value of height into w25
        mul     w26,w23,w24 //Multiply width (w23) by length (w24) and store it to w26
        mul     w26,w26,w25 //Multiply by height (w25) to get volume and store that into w26
        str     w26,[x1,cubvolume] //Store calculated value of volume to the stack

        ldp     fp,lr,[sp],16 //Deallocate space
        ret //Return to main


//=========================================================================== END OF MOVE ===================================================================================================================================================

//========================================================================== START OF PRINTCUBOID ==========================================================================================================================================
printCuboid:
	stp	fp,lr,[sp,-16]!//Allocate 16 bytes of space
	mov	fp,sp //Move fp to sp

	mov	x19,x0 //Set the name to x19 (first or second)
	mov	x22,x1 // set x22 to baseaddress of cuboid 

	ldr	x0,=printCube //load string printCube into the register x0
	mov	x1,x19 //Set value of x1 in the string to x19 (first or second)
	ldr	x2,[x22,pointorigin+pointx] //Set second value of the string to pointx
	ldr	x3,[x22,pointorigin+pointy] //Set third value of the string to pointy 
	ldr	x4,[x22,dimbase+dimwidth] //Set the fourth value of the string to width
	ldr	x5,[x22,dimbase+dimlength] //Set the fifth value of the string to length
	ldr	x6,[x22,cubheight] //Set the sixth value of the string to the height
	ldr	x7,[x22,cubvolume] //Set the seventh value of the string to the volume
	bl	printf //Print the string

	ldp	fp,lr,[sp],16 //Deallocate space
	ret	//Return to main

//================================================================== END OF PRINTCUBOID ======================================================================================================================================================

//================================================================== START OF EQUALSIZE ======================================================================================================================================================
equalSize:
	stp	fp,lr,[sp,equalsalloc]! //Allocate 20 bytes of space
	mov	fp,sp //Move fp to sp

	mov	x10,False //Set value of register x10 to False
	str	x10,[fp,result] //Store register x10 to the stack (result = False)
	
	ldr	x11,[x1,dimbase+dimwidth] //Load the width of the first cuboid and store it into register x11
	ldr	x12,[x2,dimbase+dimwidth] //Load the width of the second cuboid and store it into register x12

	cmp	x11,x12 //Compare the width values of cuboid1 and cuboid2
	b.ne	end //If the widths do not equal branch to end

	ldr	x13,[x1,dimbase+dimlength] //Load the length of the first cuboid and store it into register x13
	ldr	x14,[x2,dimbase+dimlength] //Load the length of the second cuboid and store it into register x14

	cmp	x13,x14 //Compare the length values of cuboid1 and cuboid2
	b.ne	end //If the lengths do not equal branch to end

	ldr	x15,[x1,cubheight] //Load the height of the first cuboid and store it into register x15
	ldr	x16,[x2,cubheight] //Load the heigh of the second cuboid and store it into register x16
	
	cmp	x15,x16//Compare the height values of cuboid1 and cuboid2
	b.ne	end//If the heights do not equal branch to end

	mov	x10,True //Set the value of register x10 to True (result =True)
	str	x10,[fp,result] //Store the value of x10 to the stack


end:
	ldr	x8,[fp,result] //Load the value of result into the register x8
	ldp	fp,lr,[sp],equalsdealloc //Deallocate the space 
	ret //Return to main

//====================================================================================== END OF EQUALSIZE ====================================================================================================================================

//====================================================================================== START OF MAIN =======================================================================================================================================	
main:
	stp	fp,lr,[sp,alloc]! //Allocate 48 bytes of space 
	mov	fp,sp //Move fp to sp
	
	add	firstbase,fp,first //Add 16 to sp and store it into firstbase
	add	secondbase,fp,second //Add 40 to sp and store it into secondbase

	mov	x8,firstbase //Set register x8 to value fo firstbase
	bl	newCuboid //Link to newCuboid
gdb1:
	mov	x8,secondbase //Set register x8 to value of secondbase
	bl	newCuboid //Link to newCuboid
gdb2:
	ldr	x0,=initialCuboid //Load initialCuboid string into register x0
	bl	printf //Print initialCuboid

	ldr	x0,=printFirst //Load printFirst string into register x0
	mov	x1,firstbase //set x1 to value of firstbase
	bl	printCuboid//Link to printCuboid

	ldr	x0,=printSecond//Load printSecond string into register x0
	mov	x1,secondbase//Set x1 to value of secondbase
	bl	printCuboid//Link to printCuboid
	
	mov	x1,firstbase //Set value of x1 to firstbase
	mov	x2,secondbase //Set value of x2 to secondbase
	bl	equalSize //Link to equalSize

	cmp	x8,True //Compare register x8 to True
	b.ne	end //If x8 does not equal true link to end

if:
	add	firstbase,fp,first
	mov	x1,firstbase //Set register x1 to value of firstbase
	mov	w2,3 //Set value of w2 to 3
	mov	w3,-6 //Set value of w3 to -6
	bl	move //Link to move
gdb3:
	add	secondbase,fp,second
	mov	x1,secondbase //Set value of x1 to secondbase
	mov	w2,4 //Set register w1 to value of 4
	bl	scale//Link to scale
gdb4:	
	ldr	x0,=changedCuboid//Load string changedCuboid into register x0
	bl	printf //Print changedCuboid
	
	ldr	x0,=printFirst //Load string printFirst into register x0
	add	firstbase,fp,first
	mov	x1,firstbase //Set register x1 to value of firstbase
	bl	printCuboid //link to printCuboid

	ldr	x0,=printSecond //Load string printSecond into register x0
	add     secondbase, fp, second
	mov	x1,secondbase//Set value of register x1 to secondbase
	bl	printCuboid//Link to printCuboid	

	ldp	fp,lr,[sp],dealloc //Deallocate space
	ret //Return to OS

//======================================================================================================== END OF MAIN ======================================================================================================================
