//File:assign3.asm
//UCID:30127307
//Course: CPSC355 F22
//Name:Maad Ahmed Abbasi
//Description
//======================================================= PRINT FUNCTIONS =====================================================================================================================================================================
string_2:.string "Sorted Array:\n" //Indicates the sorted array

string_1: .string "v[%d]: %d\n"// Used to print each individual element of the array


//================================================================= END PRINT FUNCTIONS =====================================================================================================================================================




//================================================================= DEFINE REGISTERS ========================================================================================================================================================
define(i,w19)
define(j,w20)
define(randomnum,w21)
define(v1,w22)
define(v2,w23)
define(temp,w24)


fp .req x29
lr .req x30

//=============================================================== END DEFINE REGISTERS ======================================================================================================================================================




//================================================== LOCAL VARIABLES ========================================================================================================================================================================
	arrlength = 40
	arrbase = 24
	elementsize = 4
	arrsize  = elementsize * arrlength
	sizei = 4
	sizej = 4
	locotemp = -4
	alloc = -(16+sizei +  sizej + arrsize )&-16
	dealloc = -alloc
	locoi = 16
	locoj = 20

//================================================== END LOCAL VARIABLES ====================================================================================================================================================================




//================================================================= START OF MAIN ===========================================================================================================================================================
	.balign 4
	.global main
main:
	stp	fp,lr,[sp,alloc]! //Allocating space
	mov	fp,sp

	add	x28,fp,arrbase //Calculating the arraybase address
	
	mov	i,0 //Initializing i to be value of 0
	str	i,[fp,locoi]//Writing i to stack
	





//=========================================================================== END OF MAIN ===================================================================================================================================================




//========================================================= CREATING UNSORTED ARRAY =========================================================================================================================================================
test1:
	ldr	i,[fp,locoi] //Loading in value of i
        cmp     i,arrlength //Comparing i with arrsize 
        b.eq    afterloop //If i is equal to arraylength then link to end


	
loop1:
	ldr	i,[fp,locoi] //Load index i from the stack
	bl	rand	//Generate random numbers

	and	randomnum,w0,0xFF//Make sure it is divisible by 0xFF
	str	randomnum,[x28,i,SXTW 2] //store randomarr into the stack
	
	ldr	w0,=string_1 //Loading string 1 which is what we will use to pring out our values
	mov	w1,i	//Moving the value of i into register w1 
	mov	w2,randomnum	//Moving value of random number into register w2
	bl	printf	//Printing it out
	
	

	add	i,i,1 //Incrementing i by 1
	str	i,[fp,locoi] //Writing i to the stack
	b	test1	//Link back to test1
//============================================================== UNSORTED ARRAY CREATED a====================================================================================================================================================
debug1:



//============================================================== SORTING ARRAY ==============================================================================================================================================================

afterloop:
	mov	i,39 //Set i to a start value of 39
	str	i,[fp,locoi] //Writing i to the stack

outerlooptest:
	ldr	i,[fp,locoi] // Loading in i from stack
	cmp	i,0 // Comapring i with 0
	b.lt	sortedarraystring //Link to sortedarraystring if i is less than 0
	
outerloop:
	mov	j,1 //Set value of j to 1
	str	j,[fp,locoj] //Store j to the stack

innerlooptest:
	ldr	i,[fp,locoi] // Load i from the stack
	ldr	j,[fp,locoj] // Load j from the stack
	cmp	j,i // Compare j and i
	b.gt	outeriincrement // If j is greater than i then link to outeriincrement 



innerloop:
	ldr	v1,[x28,j,SXTW 2] //Loading in v1 v[j]
	sub	j,j,1 //Decrement j by 1 for v[j-1]
	ldr	v2,[x28,j,SXTW 2] // Loading in v2 v[j-1]
	cmp	v1,v2	//Comparing v1 with v2
	b.ge	innerjincrement //If v1 is greater than or equal to v2 link to innerjincrement



if:
	add	sp,sp, -4 & -16 //Allocate space to store to stack
	mov	temp,v2 //temp = v[j-1]
	str	temp,[fp,locotemp] //Store temp to the stack

	mov	v2,v1 //v[j-1]=v[j]
	str	v2,[x28,j,SXTW 2] //Store v2 to the stack
	add	j,j,1	//increment j by 1 
	ldr	v1,[fp,locotemp] //Load v1 from the stack 
	str	v1,[x28,j,SXTW 2] //Store v1 to stack with incremented value of j
	add	sp,sp,16 //Deallocate space


innerjincrement:
	ldr	j,[fp,locoj]//Load j from the stack
	add	j,j,1 //Increment j by 1
	str	j,[fp,locoj] //Store j back into the stack
	b	innerlooptest//Link back to inner loop test


outeriincrement:
	ldr	i,[fp,locoi]//Load i from the stack
	sub 	i,i,1//Decrement i by 1
	str	i,[fp,locoi]//Store i to the stack
	b	outerlooptest//Link back to outerloop test

//================================================================================= ARRAY HAS BEEN SORTED ===================================================================================================================================
debug2:



//================================================================================ PRINTING OUT SORTED ARRAY ================================================================================================================================

sortedarraystring:
	ldr	w0,=string_2//Load string_2 to be printed to (Sorted Array:)
	bl	printf //Printing it out
	mov	i,0 //Set i to 0 
	str	i,[fp,locoi]//Store i to the stack


printtest:
        ldr     i,[fp,locoi] //Loading in value of i
        cmp     i,arrlength //Comparing i with arraylength
        b.eq    end //If i is eqial to arraylength then the loop link to end

printloop:

        ldr     w0,=string_1 //Loading string 1 which is what we will use to pring out our values
        ldr     w1,[fp,locoi]    //Moving the value of i into register w1
        ldr     w2,[x28,i,SXTW 2]    //Moving value of random number into register w2
        bl      printf  //Printing it out



        add     i,i,1 //Incrementing i by 1
        str     i,[fp,locoi] //Storing incremented value of 1
        b       printtest   //Link back to test1


end:
        ldp	fp,lr,[sp],dealloc //Deallocate space that was created in main
	ret

//===================================================================================          FINISHED :D        ===========================================================================================================================








