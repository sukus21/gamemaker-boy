//GameMaker things
show_debug_overlay(true);
window_set_position(50, 50);
room_speed = 60;

//Init everything
timer_init();
cpu_init();
mmap_init();
rom_init();
lcd_init();
disassembler_init();

//Load ROM
rom_load();

justgo = false;
brkp = 0xFFFF;

//Debug strings
memview = "";
mempos = 0;
regview = "";
vidview = "";

debug_8800 = surface_create(256, 256);
debug_8C00 = surface_create(256, 256);