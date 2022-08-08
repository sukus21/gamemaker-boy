//Debug things
holdtimer = keyboard_check(vk_space) ? holdtimer+1 : 0;
if(keyboard_check_pressed(vk_shift)) then justgo = !justgo;
if(keyboard_check_pressed(vk_control)) then ins_ps = get_integer("Instructions per frame", ins_ps);
if(keyboard_check_pressed(vk_backspace)) then brkp = todec(get_string("Breakpoint", tohex_pad(brkp, 4)));
if(keyboard_check_pressed(vk_return)) then gameboy_reset();
if(keyboard_check_pressed(vk_alt)) then mempos = todec(get_string("Memory position", tohex_pad(mempos, 4)));
if(keyboard_check_pressed(vk_f1)) then bytes[1] = todec(get_string("bytes[1]", bytes[1]));
if(keyboard_check_pressed(vk_f2)) then buffer_save(vram_buffer, "vbuffer");
if(keyboard_check_pressed(vk_multiply)) then gameboy_reset(false);

//Change a variable
if(keyboard_check_pressed(ord("C"))) {
	var _var = get_string("variable to change", "sp");
	if(variable_instance_exists(id, _var)) {
		var _val = todec(get_string("Value to set (in hex)", tohex(variable_instance_get(id, _var))));
		variable_instance_set(id, _var, _val);
	}
}

//Execution loop
if(justgo) then execframe = true;
while(execframe) 
	gameboy_run();

if(keyboard_check_pressed(vk_space) or holdtimer > room_speed / 3)
	for(var i = 0; i < (keyboard_check_pressed(vk_space) == true ? 1 : ins_ps); i++) {
		gameboy_run();
}

//for(var j = 0; (j < ins_ps and justgo) or (j == 0 and !justgo); j++) {
//	if(keyboard_check_pressed(vk_space) or holdtimer > room_speed / 3 or justgo) {
		
//		cpu_execute();
//		lcd_run();
//		timer_run();
//		cpu_interupt();
//		cpu_fetch();
		
//		//Breakpoint
//		if(pc == brkp) then justgo = false;
//	}
//}



//Register viewer
regview =  "af:   " + tohex_pad(af, 4) + "\n";
regview += "bc:   " + tohex_pad(bc, 4) + "\n";
regview += "de:   " + tohex_pad(de, 4) + "\n";
regview += "hl:   " + tohex_pad(hl, 4) + "\n";
regview += "sp:   " + tohex_pad(sp, 4) + "\n";
regview += "pc:   " + tohex_pad(buffer_tell(mmap), 4) + "\n\n";
regview += "Z:" + string(fZ) + "  N:" + string(fN) + "  H:" + string(fH) + "  C:" + string(fC);

//LCD register viewer
var _tell = buffer_tell(mmap);
buffer_seek(mmap, buffer_seek_start, LCDC);
vidview = "LCDC: " + tohex(buffer_read(mmap, buffer_u8)) + "\n";
vidview += "STAT: " + tohex(buffer_read(mmap, buffer_u8)) + "\n";
buffer_read(mmap, buffer_u8);
buffer_read(mmap, buffer_u8);
vidview += "CNT: " + string(cycles) + "\n";
vidview += "LY: " + string(buffer_read(mmap, buffer_u8)) + "\n";
vidview += "LYC: " + string(buffer_read(mmap, buffer_u8)) + "\n";
vidview += "IE: " + tohex(buffer_peek(mmap, IE, buffer_u8)) + "\n";
vidview += "IF: " + tohex(buffer_peek(mmap, IF, buffer_u8));

//Memory viewer
buffer_seek(mmap, buffer_seek_start, mempos);
memview = "";
for(var i = 0; i < 16; i++) {
	memview += "$" + tohex_pad(mempos+i*8, 4) + ": ";
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8));
	memview += " " + tohex(buffer_read(mmap, buffer_u8)) + "\n";
}

//Return tell to original state
buffer_seek(mmap, buffer_seek_start, _tell);

