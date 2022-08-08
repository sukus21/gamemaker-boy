//16bit registers
#macro af ((a<<8) + (fZ<<7) + (fN<<6) + (fH<<5) + (fC<<4))
#macro bc ((b<<8)+c)
#macro de ((d<<8)+e)
#macro hl ((h<<8)+l)
#macro op16 ((bytes[2]<<8)+bytes[1])

//Interupt bits
#macro INT_VBLANK 0
#macro INT_STAT 1
#macro INT_TIMER 2
#macro INT_SERIAL 3
#macro INT_JOYPAD 4

function cpu_init() {
	
	//Other things
	vec_interupt = [0x40, 0x48, 0x50, 0x58, 0x60];
	ins_ps = 100;
	
	//Cached variables for more SPEED!
	if_cache = 0;
	ie_cache = 0;
	
	//Reset
	cpu_reset();
	
	//Populate instruction pointers
	optable = scr_cpu_instructions_new();
	
	//Populate cycle count
	cytable = [
		4,  12, 8,  8,  4,  4,  8,  4,      20, 8,  8,  8,  4,  4,  8,  4,
		4,  12, 8,  8,  4,  4,  8,  4,      12, 8,  8,  8,  4,  4,  8,  4,
		8,  12, 8,  8,  4,  4,  8,  4,      8,  8,  8,  8,  4,  4,  8,  4,
		8,  12, 8,  8,  12, 12, 12, 4,      8,  8,  8,  8,  4,  4,  8,  4,
																	 	  	   	 
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		8,  8,  8,  8,  8,  8,  4,  8,      4,  4,  4,  4,  4,  4,  8,  4,

		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
		4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4,  4,  4,  4,  8,  4,
	
		8,  12, 12, 16, 12, 16, 8,  16,     8,  16, 12, 8,  12, 24, 8,  16,
		8,  12, 12, 0,  12, 16, 8,  16,     8,  16, 12, 0,  12, 0,  8,  16,
		12, 12, 8,  0,  0,  16, 8,  16,     16, 4,  16, 0,  0,  0,  8,  16,
		12, 12, 8,  4,  0,  16, 8,  16,     12, 8,  16, 4,  0,  0,  8,  16
	];
	
	//Populate byte count
	//bytable = [
	//	1,3,1,1, 1,1,2,1, 3,1,1,1, 1,1,2,1,
	//	2,3,1,1, 1,1,2,1, 2,1,1,1, 1,1,2,1,
	//	2,3,1,1, 1,1,2,1, 2,1,1,1, 1,1,2,1,
	//	2,3,1,1, 1,1,2,1, 2,1,1,1, 1,1,2,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
	//	1,1,3,3, 3,1,2,1, 1,1,3,1, 3,3,2,1,
	//	1,1,3,1, 3,1,2,1, 1,1,3,1, 3,1,2,1,
	//	2,1,1,1, 1,1,2,1, 2,1,3,1, 1,1,2,1,
	//	2,1,1,1, 1,1,2,1, 2,1,3,1, 1,1,2,1
	//];
}

function cpu_reset() {
	
	//Main registers
	a = 0x01;
	b = 0x00;
	c = 0x13;
	d = 0x00;
	e = 0xD8;
	h = 0x01;
	l = 0x4D;
	sp = 0xFFFE;
	ime = false;
	
	//Flags
	fZ = true;
	fN = false;
	fH = true;
	fC = true;
	
	//Other things
	ei_active = false;
	cpu_halted = false;
	execframe = false;
	
	//Variable, scary
	opcode = 0;
}

function cpu_run() {
	
	//If halted
	if(cpu_halted) {
		cycles -= 4;
		return;
	}
	
	//Read the next instruction and get the mnemonic
	opcode = buffer_read(mmap, buffer_u8);
	cycles_c = cytable[opcode];
	
	//EI does the thing
	if(ei_active) {
		ime = true;
		ei_active = false;
	}
		
	//Increment PC and execute the instruction
	optable[opcode]();
	cycles -= cycles_c;
}

function cpu_interupt() {
	
	if(!ime)
		return;
	
	//Woa
	if!(if_cache & ie_cache)
		return;
	
	//Variables
	var _int = 0;
				
	//Figure out which interupt was triggered
	for( ; _int < 5; _int++)
		if((if_cache >> _int) & 0x01 and (ie_cache >> _int) & 0x01)
			break;
				
	//Disable interupts
	ime = false;
	var _newif = if_cache ^ (if_cache & ie_cache);
	if_cache = _newif & 0x1F;
	buffer_poke(mmap, IF, buffer_u8, if_cache);
				
	//Jump
	cycles += 20;
	var mv = buffer_tell(mmap);
	push_16
	buffer_seek(mmap, buffer_seek_start, vec_interupt[_int]);
			
	//Un-halt the CPU
	cpu_halted = false;
}

function int_request(_bit) {
	
	//var _o = if_cache;
	if_cache |= (1<<_bit);
	if(if_cache & ie_cache and cpu_halted) {
		cpu_halted = false;
		//if_cache = _o;
	}
	
	buffer_poke(mmap, IF, buffer_u8, if_cache);
}