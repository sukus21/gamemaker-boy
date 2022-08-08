function disassembler_init() {
	
	disassembler_table_main = [
		"nop", "ld bc, n16", "ld [bc], a", "inc bc", "inc b", "dec b", "ld b, n8", "rlca", "ld [n16], sp", "add hl, bc", "ld a, [bc]", "dec bc", "inc c", "dec c", "ld c, n8", "rrca",
		"stop", "ld de, n16", "ld [de], a", "inc de", "inc d", "dec d", "ld d, n8", "rla", "jr e8", "add hl, de", "ld a, [de]", "dec de", "inc e", "dec e", "ld e, n8", "rra",
		"jr nz, e8", "ld hl, n16", "ld [hl+], a", "inc hl", "inc h", "dec h", "ld h, n8", "daa", "jr z, e8", "add hl, hl", "ld a, [hl+]", "dec hl", "inc l", "dec l", "ld l, n8", "cpl",
		"jr nc, e8", "ld sp, n16", "ld [hl-], a", "inc sp", "inc [hl]", "dec [hl]", "ld [hl], n8", "scf", "jr c, e8", "add hl, sp", "ld a, [hl-]", "dec sp", "inc a", "dec a", "ld a, n8", "ccf",
	
		"ld b, r8", "ld b, r8", "ld b, r8", "ld b, r8", "ld b, r8", "ld b, r8", "ld b, r8", "ld b, r8",    "ld c, r8", "ld c, r8", "ld c, r8", "ld c, r8", "ld c, r8", "ld c, r8", "ld c, r8", "ld c, r8",
		"ld d, r8", "ld d, r8", "ld d, r8", "ld d, r8", "ld d, r8", "ld d, r8", "ld d, r8", "ld d, r8",    "ld e, r8", "ld e, r8", "ld e, r8", "ld e, r8", "ld e, r8", "ld e, r8", "ld e, r8", "ld e, r8",
		"ld h, r8", "ld h, r8", "ld h, r8", "ld h, r8", "ld h, r8", "ld h, r8", "ld h, r8", "ld h, r8",    "ld l, r8", "ld l, r8", "ld l, r8", "ld l, r8", "ld l, r8", "ld l, r8", "ld l, r8", "ld l, r8",
		"ld [hl], r8", "ld [hl], r8", "ld [hl], r8", "ld [hl], r8", "ld [hl], r8", "ld [hl], r8", "halt", "ld [hl], r8",    "ld a, r8", "ld a, r8", "ld a, r8", "ld a, r8", "ld a, r8", "ld a, r8", "ld a, r8", "ld a, r8",
		
		"add a, r8", "add a, r8", "add a, r8", "add a, r8", "add a, r8", "add a, r8", "add a, r8", "add a, r8", "adc a, r8", "adc a, r8", "adc a, r8", "adc a, r8", "adc a, r8", "adc a, r8", "adc a, r8", "adc a, r8", 
		"sub a, r8", "sub a, r8", "sub a, r8", "sub a, r8", "sub a, r8", "sub a, r8", "sub a, r8", "sub a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", "sbc a, r8", 
		"and a, r8", "and a, r8", "and a, r8", "and a, r8", "and a, r8", "and a, r8", "and a, r8", "and a, r8", "xor a, r8", "xor a, r8", "xor a, r8", "xor a, r8", "xor a, r8", "xor a, r8", "xor a, r8", "xor a, r8", 
		"or a, r8", "or a, r8", "or a, r8", "or a, r8", "or a, r8", "or a, r8", "or a, r8", "or a, r8", "cp a, r8", "cp a, r8", "cp a, r8", "cp a, r8", "cp a, r8", "cp a, r8", "cp a, r8", "cp a, r8", 
		
		"ret nz", "pop bc", "jp nz, n16", "jp n16", "call nz, n16", "push bc", "add a, n8", "rst $0000", "ret z", "ret", "jp z, n16", 0xCB, "call z, n16", "call n16", "adc a, n8", "rst $0008", 
		"ret nc", "pop de", "jp nc, n16", "inv", "call nc, n16", "push de", "sub a, n8", "rst $0010", "ret c", "reti", "jp c, n16", "inv", "call c, n16", "inv", "sbc a, n8", "rst $0018", 
		"ldh [n8], a", "pop hl", "ldh [c], a", "inv", "inv", "push hl", "and a, n8", "rst $0020", "add sp, e8", "jp hl", "ld [n16], a", "inv", "inv", "inv", "xor a, n8", "rst $0028", 
		"ldh a, [n8]", "pop af", "ldh a, [c]", "di", "inv", "push af", "or a, n8", "rst $0030", "ld hl, sp+e8", "ld sp, hl", "ld a, [n16]", "ei", "inv", "inv", "cp a, n8", "rst $0038"
	];
	
	disassembler_table_sub = array_create(256, -1);
	
	//Rotate instructions
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i] = "rlc r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x08] = "rrc r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x10] = "rl r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x18] = "rr r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x20] = "sla r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x28] = "sra r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x30] = "swap r8";
	
	for(var i = 0; i < 8; i++)
		disassembler_table_sub[i+0x38] = "srl r8";
	
	//Bit instructions
	for(var i = 0; i < 64; i++)
		disassembler_table_sub[i+0x40] = "bit n3, r8";
	
	//Res instructions
	for(var i = 0; i < 64; i++)
		disassembler_table_sub[i+0x80] = "res n3, r8";
	
	//Set instructions
	for(var i = 0; i < 64; i++)
		disassembler_table_sub[i+0xC0] = "set n3, r8";
}

function sign8(_in) {
	var mv = _in;
	sign_8;
	return mv;
}

function disassemble_opcode(_bytes) {
	
	static _registers = ["b", "c", "d", "e", "h", "l", "[hl]", "a"];
	
	var _name = disassembler_table_main[_bytes[0]];
	
	//Prefix
	if(_name == 0xCB) {
		_name = disassembler_table_sub[_bytes[1]];
		_name = string_replace(_name, "r8", _registers[_bytes[1] & 0x07]);
		_name = string_replace(_name, "n3", string((_bytes[1] >> 3) & 0x07));
		return _name;
	}
	
	_name = string_replace(_name, "n8", "$"+tohex(_bytes[1]));
	_name = string_replace(_name, "n16", "$"+tohex_pad(((_bytes[2]<<8)+_bytes[1]), 4));
	_name = string_replace(_name, "e8", string(sign8(_bytes[1])) + "($" + tohex(_bytes[1]) + ")");
	_name = string_replace(_name, "r8", _registers[_bytes[0] & 0x07]);
	return _name;
}