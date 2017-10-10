// ninja.asm

// setup
arch 	snes.cpu
origin 	0x000000
insert 	"original.sfc" 			// rom name must be original.sfc!

origin 	0x009645 				// change menu screen text
db 		"NINJA GAIDEN TRILOGY" 
db 		$FF
db 		" HACK BY CYJORG "

scope buttons {
	// byetUDLRaxlr0000 (e = select, t = start)
	// b = $8000
	// y = $4000
	// a = $0080

	constant JUMP_A($0000) 		// slash with b, jump with a
	constant JUMP_B($FFFF) 		// slash with y, jump with b

	origin 	0x000424
	base  	0x808424
	jmp 	Start
	Return:

	origin 	0x000800
	base 	0x808800
	Start:
	lda 	$4218,x 			// poll controller (original line)

	CheckL:
	bit 	#$0020 				// check l
	beq 	CheckR 				// if l not pressed, check r
	pha 	 					// save a on stack
	lda 	#JUMP_B 			// ~
	sta 	$7FFFFE 			// store #JUMP_B to arbitrary address
	pla 						// restore a from stack

	CheckR:
	bit 	#$0010 				// check r
	beq 	Continue 			// if r not pressed, continue
	pha 	 					// save a on stack
	lda 	#JUMP_A 			// ~
	sta 	$7FFFFE 			// store #JUMP_A to arbitrary address
	pla 						// restore a from stack

  	Continue:
	pha 	 					// save a on stack
  	lda 	$7FFFFE  			// get mode
  	cmp 	#JUMP_B 			// check if mode is #JUMP_B
  	bne 	JumpA 				// if mode is #JUMP_A, JumpA, else JumpB

	// JUMP_B mode
	JumpB:
  	pla 						// restore a from stack
	and 	#$FF00 				// turn off a, x, l, and r

	BtoA:
	bit 	#$8000 				// test y bit mask
	beq 	YtoB 				// if a not pressed, End
	and 	#$7FF0 				// turn off b
	ora 	#$0080 				// turn on a

	YtoB:
	bit 	#$4000 				// test b bit mask
	beq  	End 				// if b not pressed, check AtoB
	and 	#$BFF0 				// turn off y
	ora 	#$8000 				// turn on b

	End:
	jmp 	Return 				// return

	JumpA:
	pla 						// restore a from stack
	jmp 	Return 				// return

}

