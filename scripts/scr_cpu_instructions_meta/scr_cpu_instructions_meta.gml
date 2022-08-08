/*gml_pragma("forceinline");
//Function macro
#macro function() function()

//Opcode constructor
function opc(_name, _func, _bytes, _cycles) constructor {
	func = _func;
	size = _bytes;
	cycles = _cycles;
	name = _name;
}

//Get signed values
function sign8(_val) {
	
	if(_val&(1<<7))
		return -(-_val + 0x100);
	else
		return _val;
}

//Push a 16bit value to the stack
function stack_push(_val) {
	sp -= 2;
	if(sp < 0) then sp += 0x10000;
	mmap_write((sp+1) & 0xFFFF, (_val>>8) & 0xFF);
	mmap_write(sp, _val&0xFF);
}

//Increase 8bit number
function inc8(_val) {
	_val = ++_val & 0xFF;
	
	fZ = _val == 0;
	fN = 0;
	fH = _val & 0x0F == 0;
	
	return _val;
}

function dec8(_val) {
	_val--;
	if(_val == -1) then _val = 0xFF;
	
	fZ = _val == 0;
	fN = 1;
	fH = _val & 0x0F == 0x0F;
	
	return _val;
}

//8bit addition
function add8(_val) {
	fN = 0;
	fH = (((_val&0x0F) + (a&0x0F)) & 0x10) == 0x10;
	fC = (_val + a) > 0xFF;
	a = (a + _val) & 0xFF;
	fZ = a == 0;
}

//8bit addition with carry
function adc8(_val) {
	fN = 0;
	fH = (((_val&0x0F) + (a&0x0F) + fC) & 0x10) == 0x10;
	a += fC;
	fC = (a + _val) > 0xFF;
	a = (a + _val) & 0xFF;
	fZ = a == 0;
}

//Subtraction
function sub8(_val) {
	fN = 1;
	fH = ((a&0x0F) - (_val&0x0F)) < 0;
	fC = _val > a;
	a -= _val;
	if(a < 0) then a += 256;
	fZ = a == 0;
}
	
function sbc8(_val) {
	fN = 1;
	fH = ((a&0x0F) - (_val&0x0F) - fC) < 0;
	_val += fC;
	fC = _val > a;
	a = a - _val & 0xFF;
	fZ = a == 0;
}

//Compare functions
function cp8(_val) {
	var _a = a;
	fN = 1;
	fH = ((_a&0x0F) - (_val&0x0F)) < 0;
	fC = _val > _a;
	_a -= _val;
	fZ = _a == 0;
}

//16bit additions
function add16(_val) {
	var _res = hl + _val;
	fC = _res > 0xFFFF;
	fN = 0;
	fH = ((_val&0x0FFF) + (hl&0x0FFF)) & 0x1000 == 0x1000;
		
	h = (_res >> 8) & 0xFF;
	l = _res & 0xFF;
}

function cpu_jump(_add) {
	pc = _add & 0xFFFF;
	buffer_seek(mmap, buffer_seek_start, pc);
}

function rot_cr(_reg) {
	//Set carry flag to bit 0
	fC = _reg & 1;
	
	//Shift
	_reg = (_reg >> 1) % 0x100;
	_reg |= fC << 7;
	
	//Set other flags
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function rot_cl(_reg) {
	//Set carry flag to bit 7
	fC = (_reg >> 7) & 1;
	
	//Shift
	_reg = (_reg << 1) % 0x100;
	_reg |= fC;
	
	//Set other flags
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function rot_r(_reg) {
	//Set _p to bit 0
	var _p = _reg & 1;
	
	//Shift
	_reg = (_reg >> 1) % 0x100;
	_reg |= fC << 7;
	
	//Set flags
	fC = _p;
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function rot_l(_reg) {
	//Set _p to bit 7
	var _p = (_reg >> 7) & 1;
	
	//Shift
	_reg = (_reg<<1) % 0x100;
	_reg |= fC;
	
	//Set flags
	fC = _p;
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function srl(_reg) {
	//Set carry flag to bit 0
	fC = _reg&1;
	
	//Shift
	_reg = _reg >> 1
	
	//Mask bit 7
	_reg &= 0x7F;
	
	//Set flags
	fN = 0;
	fH = 0;
	fZ = _reg == 0;
	
	//Return
	return _reg;
}

function sla(_reg) {
	//Set carry flag to bit 7
	fC = (_reg >> 7) & 1;
	
	//Shift
	_reg = _reg << 1;
	
	//Correction
	_reg &= 0xFE;
	
	//Set other flags
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function sra(_reg) {
	//Set carry flag to bit 0
	fC = _reg & 1;
	
	//Set _p to bit 7
	var _p = _reg & 0x80;
	
	//Shift
	_reg = _reg >> 1;
	
	//Correction
	_reg &= 0x7F;
	_reg |= _p;
	
	//Set other flags
	fZ = _reg == 0;
	fH = 0;
	fN = 0;
	
	//Return
	return _reg;
}

function swap(_reg) {
	var
		_u = _reg & 0xF0, 
		_l = _reg & 0x0F;
	
	_reg = (_u >> 4) + (_l << 4);
	
	fZ = _reg == 0;
	fN = 0;
	fH = 0;
	fC = 0;
	
	//return
	return _reg;
}

//Bit functions
function bit(_reg, _bit) {
	fZ = !((_reg >> _bit) & 1);
	fH = 1;
	fN = 0;
}

function set(_reg, _bit) {
	_reg |= 1 << _bit;
	return _reg;
}

function res(_reg, _bit) {
	_reg &= (1 << _bit) ^ 0xFF;
	return _reg;
}