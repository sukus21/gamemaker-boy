draw_text(0, 0, keyboard_lastkey);

//wtf?
//buffer_copy(mmap, 0x8000, 0x2000, vram_buffer, 0);

//Write things to the VRAM buffer
buffer_copy(mmap, 0xFE00, 0xA0, vram_buffer, 0x200000 + 0x2000 * 0xFF);
buffer_copy(mmap, 0x8000, 0x2000, vram_buffer, 0x2000 * 0xFF);
buffer_seek(vram_buffer, buffer_seek_start, 0x201000 + 0x2000 * 0xFF);
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, LCDC, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, SCY, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, SCX, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, BGP, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, OBP0, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, OBP1, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, WY, buffer_u8));
buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, WX, buffer_u8));

//Ready the display surface
if(!surface_exists(vram_surface))
	vram_surface = surface_create(256*8, 256*2);
buffer_set_surface(vram_buffer, vram_surface, 0);

//Set these things
draw_set_font(fnt_8bo);
draw_set_color(c_white);

//Registers and flags
draw_text(0, 0, regview);
draw_text(140, 0, vidview);

//Memory view
draw_text(330, 0, memview);

//thing
draw_text(720, 0, "9800 tilemap");
draw_text(720, 292, "9C00 tilemap");

//Opcode information
var _text = ""; 
//for(var i = 0; i < opcode.size; i++) _text += tohex(bytes[i]) + " ";
draw_text(0, 256, _text);

//Disassembler
var _bytes = array_create(3);
_bytes[0] = buffer_read(mmap, buffer_u8);
_bytes[1] = buffer_read(mmap, buffer_u8);
_bytes[2] = buffer_read(mmap, buffer_u8);
buffer_seek(mmap, buffer_seek_relative, -3);
draw_text(0, 288, disassemble_opcode(_bytes));


//Displays
shader_set(shr_screen);
shader_set_uniform_f(uni_texx, texture_get_texel_width(surface_get_texture(vram_surface)));
shader_set_uniform_f(uni_texy, texture_get_texel_height(surface_get_texture(vram_surface)));

//Main display
shader_set_uniform_i(uni_igreg, 0);
if(!surface_exists(lcd_surface)) then lcd_surface = surface_create(256, 256);
surface_set_target(lcd_surface);
draw_surface(vram_surface, 0, 0);
surface_reset_target();

//9800 tilemap
shader_set_uniform_i(uni_igreg, 1);
if(!surface_exists(debug_8800)) then debug_8800 = surface_create(256, 256);
surface_set_target(debug_8800);
draw_surface(vram_surface, 0, 0);
surface_reset_target();

//9C00 tilemap
shader_set_uniform_i(uni_igreg, 2);
if(!surface_exists(debug_8C00)) then debug_8C00 = surface_create(256, 256);
surface_set_target(debug_8C00);
draw_surface(vram_surface, 0, 0);
surface_reset_target();

shader_reset();

//Draw surfaces
draw_surface_part_ext(lcd_surface, 0, 0, 160, 144, 0, 320, 2, 2, -1, 1);
draw_surface(debug_8800, 720, 32);
draw_surface(debug_8C00, 720, 260+64);

//Screenshot tools
if(keyboard_check_pressed(vk_f2)) then surface_save(lcd_surface, "pee.png");
if(keyboard_check_pressed(vk_f2)) then surface_save(vram_surface, "vram.png");