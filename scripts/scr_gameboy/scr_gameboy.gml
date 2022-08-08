function gameboy_reset(_newfile = true) {
	
	//Reset everything
	cpu_reset();
	lcd_reset();
	mmap_reset();
	timer_reset();
	rom_reset();
	
	//Load new ROM
	rom_file = "";
	while(rom_file == "")
		rom_load(_newfile);
}

//Run the entire thing
function gameboy_run() {
	cpu_run();
	lcd_run();
	timer_run();
	cpu_interupt();
		
	//Breakpoint
	if(buffer_tell(mmap) == brkp) {
		execframe = false;
		justgo = false;
	}
}