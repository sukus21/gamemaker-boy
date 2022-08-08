#macro MBC_NONE 0
#macro MBC1 1
#macro MBC2 2
#macro MBC3 3
#macro MBC5 4
#macro MBC6 5
#macro MBC7 6
#macro MMM01 7


function rom_init() {
	rom = -1;
	rom_ram = -1;
	rom_ram_bank_current = 0;
	rom_file = -1;
	
	rom_reset();
}

function rom_reset() {
	rom_banks = 2;
	rom_ram_banks = 0;
	
	rom_mbc = MBC_NONE;
	rom_ram_size = 0;
	rom_hasram = false;
	rom_hasbattery = false;
}

function rom_write(_add, _byte) {
	switch(rom_mbc) {
		case MBC_NONE: return;
		default: {
			if(_add >= 0x2000 && _add < 0x4000) then rom_switch_rbank(_byte);
			if(_add >= 0x4000 && _add < 0x5FFF) then rom_switch_sbank(_byte);
			break;
		}
		//default: show_message("This MBC is not implemented yet :)"); break;
	}
}

function rom_switch_rbank(_bank) {
	buffer_copy(rom, _bank * 0x4000, 0x4000, mmap, 0x4000);
}

function rom_switch_sbank(_bank) {
	
	//Copy contents of current SRAM bank to the rom_ram buffer
	buffer_copy(mmap, r_SRAM, rom_ram_size, rom_ram, rom_ram_bank_current * rom_ram_size);
	
	//Copy contents of selected SRAM bank to the memory map
	buffer_copy(rom_ram, _bank * rom_ram_size, rom_ram_size, mmap, r_SRAM);
}

function rom_load(_newfile = true) {

	//Get and open the ROM file
	if(_newfile) {
		rom_file = get_open_filename("","");
		if(rom_file == "") then return;
		var _rom_read = file_bin_open(rom_file, 0);
	
		//Import header
		var _header = buffer_create(0x150, buffer_fast, 1);
		buffer_seek(_header, buffer_seek_start, 0);
		for(var i = 0; i < 0x150; i++)
			buffer_write(_header, buffer_u8, file_bin_read_byte(_rom_read));
		
		//Get cartrige type
		switch(buffer_peek(_header, 0x0147, buffer_u8)) {
			case 0x00: break;
			case 0x01: rom_mbc = MBC1; break;
			case 0x02: rom_mbc = MBC1; rom_hasram = true; break;
			case 0x03: rom_mbc = MBC1; rom_hasram = true; rom_hasbattery = true; break;
		
			case 0x05: rom_mbc = MBC2; break;
			case 0x06: rom_mbc = MBC2; rom_hasbattery = true; break;
		
			case 0x08: rom_hasram = true; break;
			case 0x09: rom_hasram = true; rom_hasbattery = true; break;
		
			case 0x0B: rom_mbc = MMM01; break;
			case 0x0C: rom_mbc = MMM01; rom_hasram = true; break;
			case 0x0D: rom_mbc = MMM01; rom_hasram = true; rom_hasbattery = true; break;
		
			case 0x11: rom_mbc = MBC3; break;
			case 0x12: rom_mbc = MBC3; rom_hasram = true; break;
			case 0x13: rom_mbc = MBC3; rom_hasram = true; rom_hasbattery = true; break;
		
			case 0x19: rom_mbc = MBC5; break;
			case 0x1A: rom_mbc = MBC5; rom_hasram = true; break;
			case 0x1B: rom_mbc = MBC5; rom_hasram = true; rom_hasbattery = true; break;
			case 0x1C: rom_mbc = MBC5; break;
			case 0x1D: rom_mbc = MBC5; rom_hasram = true; break;
			case 0x1E: rom_mbc = MBC5; rom_hasram = true; rom_hasbattery = true; break;
		
			case 0x20: rom_mbc = MBC6; break;
			case 0x22: rom_mbc = MBC7; rom_hasram = true; rom_hasbattery = true; break;
		
			case 0xFC:
			case 0xFD:
			case 0xFE:
			case 0xFF: show_message("Unsupported cartrige type"); break;
		
			default: show_message("Invalid cartrige type"); break;
		}
	
		//Get ROM size
		switch(buffer_peek(_header, 0x0148, buffer_u8)) {
			case 0x00: rom_banks = 2; break;
			case 0x01: rom_banks = 4; break;
			case 0x02: rom_banks = 8; break;
			case 0x03: rom_banks = 16; break;
			case 0x04: rom_banks = 32; break;
			case 0x05: rom_banks = 64; break;
			case 0x06: rom_banks = 128; break;
			case 0x07: rom_banks = 256; break;
			case 0x08: rom_banks = 512; break;
		
			case 0x52: rom_banks = 72; break;
			case 0x53: rom_banks = 80; break;
			case 0x54: rom_banks = 96; break;
		
			default: {
				show_message("Invalid amount of ROM-banks in header, please specify:");
				rom_banks = get_integer("Number of ROM-banks in ROM:", 2);
				break;
			}
		}
		var _romsize = 0x4000 * rom_banks;
		file_bin_seek(_rom_read, 0);
	
		//Get SRAM size
		switch(buffer_peek(_header, 0x0149, buffer_u8)) {
			case 0x00: rom_ram_banks = 0; rom_ram_size = 0; break;
			case 0x01: rom_ram_banks = 1; rom_ram_size = 0x800; break;
			case 0x02: rom_ram_banks = 1; rom_ram_size = 0x2000; break;
			case 0x03: rom_ram_banks = 4; rom_ram_size = 0x2000; break;
			case 0x04: rom_ram_banks = 16; rom_ram_size = 0x2000; break;
			case 0x05: rom_ram_banks = 8; rom_ram_size = 0x2000; break;
			default: show_message("Invalid amount of RAM on cartrige"); break;
		}
	
		//Import full rom
		if(buffer_exists(rom))
			buffer_delete(rom);
	
		rom = buffer_create(_romsize, buffer_fast, 1);
		buffer_seek(rom, buffer_seek_start, 0);
		for(var i = 0; i < _romsize; i++)
			buffer_write(rom, buffer_u8, file_bin_read_byte(_rom_read));
	
		//Close the file
		file_bin_close(_rom_read);
		
		//Delete header buffer
		buffer_delete(_header);
	}
	else {
		rom_file = "what";
	}
	//Copy bank 0 and bank 1 into the memory map
	buffer_copy(rom, 0, 0x8000, mmap, 0);
	buffer_seek(mmap, buffer_seek_start, 0x0100);
	
	//Initialize Sram buffer
	rom_ram = buffer_create(rom_ram_banks * rom_ram_size, buffer_fast, buffer_u8);
}