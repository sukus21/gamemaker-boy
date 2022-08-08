function mmap_init() {
	mmap = buffer_create(0x10000, buffer_fast, 1);
	mmap_reset();
}

function mmap_reset() {
	//Clear the entire buffer
	buffer_seek(mmap, buffer_seek_start, 0);
	for(var i = 0; i < 0x10000; i++)
		buffer_write(mmap, buffer_u8, 0);
	
	//IO registers
	buffer_poke(mmap, TIMA, buffer_u8, 0x00);
	buffer_poke(mmap, TMA, buffer_u8, 0x00);
	mmap_write(TAC, 0x00);
	buffer_poke(mmap, 0xFF10, buffer_u8, 0x80);
	buffer_poke(mmap, 0xFF11, buffer_u8, 0xBF);
	buffer_poke(mmap, 0xFF12, buffer_u8, 0xF3);
	buffer_poke(mmap, 0xFF14, buffer_u8, 0xBF);
	buffer_poke(mmap, 0xFF16, buffer_u8, 0x3F);
	buffer_poke(mmap, 0xFF17, buffer_u8, 0x00);
	buffer_poke(mmap, 0xFF19, buffer_u8, 0xBF);
	buffer_poke(mmap, 0xFF1A, buffer_u8, 0x7F);
	buffer_poke(mmap, 0xFF1B, buffer_u8, 0xFF);
	buffer_poke(mmap, 0xFF1C, buffer_u8, 0x9F);
	buffer_poke(mmap, 0xFF1E, buffer_u8, 0xBF);
	buffer_poke(mmap, 0xFF20, buffer_u8, 0xFF);
	buffer_poke(mmap, 0xFF21, buffer_u8, 0x00);
	buffer_poke(mmap, 0xFF22, buffer_u8, 0x00);
	buffer_poke(mmap, 0xFF23, buffer_u8, 0xBF);
	buffer_poke(mmap, 0xFF24, buffer_u8, 0x77);
	buffer_poke(mmap, 0xFF25, buffer_u8, 0xF3);
	buffer_poke(mmap, 0xFF26, buffer_u8, 0xF1);
	buffer_poke(mmap, LCDC, buffer_u8, 0x91);
	mmap_write(STAT, 0x85);
	buffer_poke(mmap, SCY, buffer_u8, 0x00);
	buffer_poke(mmap, SCX, buffer_u8, 0x00);
	buffer_poke(mmap, LYC, buffer_u8, 0x00);
	buffer_poke(mmap, BGP, buffer_u8, 0xFC);
	buffer_poke(mmap, OBP0, buffer_u8, 0xFF);
	buffer_poke(mmap, OBP1, buffer_u8, 0xFF);
	buffer_poke(mmap, WY, buffer_u8, 0x00);
	buffer_poke(mmap, WX, buffer_u8, 0x00);
	mmap_write(IE, 0x00);
	mmap_write(IF, 0xE1);
	
	buffer_seek(mmap, buffer_seek_start, 0x0100);
}

function mmap_read(_add) {
	
	//Read and return
	var _res = buffer_peek(mmap, _add, buffer_u8);
	return(_res);
}

function mmap_write(_add, _byte) {
	
	//Attempt to write to ROM
	if(_add < 0x8000) {
		rom_write(_add, _byte);
		return;
	}
	
	//IO things
	if(_add >= 0xFF00) then switch(_add) {
		
		case DIV: _byte = 0; break;
		case IF: _byte |= 0xE0; if_cache = _byte&0x1F; break;
		case IE: _byte |= 0xE0; ie_cache = _byte&0x1F; break;
		case STAT: _byte |= 0x80; stat_cache = _byte; break;
		case P1: {
			_byte &= 0x30;
			if(_byte != 0x30) {
					
				var _inp = 0;
				if(_byte == 0x20) {
					_inp |= !keyboard_check(vk_right);
					_inp |= (!keyboard_check(vk_left)) << 1;
					_inp |= (!keyboard_check(vk_up)) << 2;
					_inp |= (!keyboard_check(vk_down)) << 3;
				}
				else {
					_inp |= !keyboard_check(ord("Z"));
					_inp |= (!keyboard_check(ord("X"))) << 1;
					_inp |= (!keyboard_check(ord("A"))) << 2;
					_inp |= (!keyboard_check(ord("S"))) << 3;
				}
					
				_byte |= _inp;
			}
				
			break;
		}
		case DMA: {
			buffer_copy(mmap, _byte<<8, 0xA0, dma_buffer, 0);
			buffer_copy(dma_buffer, 0, 0xA0, mmap, 0xFE00);
			break;
		}
		case TAC: tac_cache = _byte; break;
	}
	
	//Write to MMAP
	buffer_poke(mmap, _add, buffer_u8, _byte);
}

#macro r_ROM0 0
#macro r_ROMX 1
#macro r_VRAM 2
#macro r_SRAM 3
#macro r_WRAM 4
#macro r_ERAM 5
#macro r_OAM 6
#macro r_FEXX 7
#macro r_IO 8
#macro r_HRAM 9

function mmap_get_region(_add) {	
	if!(_add - 0x4000 + 1) then return r_ROM0;
	if!(_add - 0x8000 + 1) then return r_ROMX;
	if!(_add - 0xA000 + 1) then return r_VRAM;
	if!(_add - 0xC000 + 1) then return r_SRAM;
	if!(_add - 0xE000 + 1) then return r_WRAM;
	if!(_add - 0xFE00 + 1) then return r_ERAM;
	if!(_add - 0xFEA0 + 1) then return r_OAM;
	if!(_add - 0xFF00 + 1) then return r_FEXX;
	if!(_add - 0xFF80 + 1) then return r_IO;
	if!(_add - 0xFFFE + 1) then return r_HRAM;
	return r_IO;
	
	//var _range = 0;
	//if(_add == clamp(_add, 0, 0x3FFF)) then _range = 0; //Rom bank 0
	//else if(_add == clamp(_add, 0x4000, 0x7FFF)) then _range = 1; //Rom bank 1
	//else if(_add == clamp(_add, 0x8000, 0x9FFF)) then _range = 2; //Vram
	//else if(_add == clamp(_add, 0xA000, 0xBFFF)) then _range = 3; //Sram
	//else if(_add == clamp(_add, 0xC000, 0xDFFF)) then _range = 4; //Wram
	//else if(_add == clamp(_add, 0xE000, 0xFDFF)) then _range = 5; //Eram
	//else if(_add == clamp(_add, 0xFE00, 0xFE9F)) then _range = 6; //Oam
	//else if(_add == clamp(_add, 0xFEA0, 0xFEFF)) then _range = 7; //Fexx
	//else if(_add == clamp(_add, 0xFF00, 0xFF7F)) then _range = 8; //I/O
	//else if(_add == clamp(_add, 0xFF80, 0xFFFE)) then _range = 9; //Hram
	//else if(_add == 0xFFFF) then _range = 8; //I/O
	
	//return _range;
}