function lcd_init() {
	
	//Shader things
	uni_texx = shader_get_uniform(shr_screen, "texx");
	uni_texy = shader_get_uniform(shr_screen, "texy");
	uni_igreg = shader_get_uniform(shr_screen, "ignoreRegs");
	
	//Variables
	vram_buffer = -1;
	vram_surface = -1;
	lcd_surface = -1;
	
	//DMA buffer
	dma_buffer = buffer_create(0xA0, buffer_fast, 1);
	
	//STAT cache, for speed
	stat_cache = 0;
	
	//Reset
	lcd_reset();
}

function lcd_reset() {
	
	//VRAM and lcd buffer/surfaces
	if(buffer_exists(vram_buffer)) buffer_delete(vram_buffer);
	vram_buffer = buffer_create(0x2000 * 512, buffer_fast, 1);
	buffer_poke(vram_buffer, 0x400000-1, buffer_u8, 0xFF);
	if(surface_exists(vram_surface)) surface_free(vram_surface);
	if(surface_exists(lcd_surface)) surface_free(lcd_surface);
	
	cycles = 56;
	lcd_state = -1;
	vblank_active = false;
}

function lcd_run() {
	
	if(cycles >= 0)
		return;
	
	//LCD state
	switch(lcd_state) {
		
		case -1: { //Startup
		
			//Switch to new state
			cycles += 80;
			lcd_state = 2;
				
			//Update STAT register
			stat_cache &= 0xFC;
			stat_cache |= 2;
			buffer_poke(mmap, STAT, buffer_u8, stat_cache);
				
			break;
		}
		case 0: { //H-blank
		
			//Change state
			cycles += 204;
			lcd_state = 2;
					
			//Next scanline
			var _ly = buffer_peek(mmap, LY, buffer_u8) + 1;
					
			//LY = LYC interupt
			if(_ly = buffer_peek(mmap, LYC, buffer_u8)) {
				stat_cache &= 0xFB;
				stat_cache |= 4;
				buffer_poke(mmap, STAT, buffer_u8, stat_cache);
				if(stat_cache & 0x40)
					int_request(INT_STAT);
			}
					
			//Activate V-blank
			if(_ly == 144) {
				vblank_active = true;
				int_request(INT_VBLANK);
			}
			else if(_ly == 154) {
				_ly = 0;
				vblank_active = false;
				execframe = false;
			}
				
			//Write LY back to mmap
			buffer_poke(mmap, LY, buffer_u8, _ly);
				
			//Copy OAM to VRAM buffer
			buffer_copy(mmap, 0xFE00, 0xA0, vram_buffer, 0x200000 + 0x2000 * _ly);
			
			break;
		}
		case 2: { //OAM search
		
			//Switch to next state
			cycles += 172;
			lcd_state = 3;
				
			//Copy VRAM to VRAM buffer
			var _ly = buffer_peek(mmap, LY, buffer_u8);
			buffer_copy(mmap, 0x8000, 0x2000, vram_buffer, 0x2000 * _ly);
				
			//Copy IO to VRAM buffer
			buffer_seek(vram_buffer, buffer_seek_start, 0x201000 + 0x2000 * _ly);
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, LCDC, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, SCY, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, SCX, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, BGP, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, OBP0, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, OBP1, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, WY, buffer_u8));
			buffer_write(vram_buffer, buffer_u8, buffer_peek(mmap, WX, buffer_u8));
			
			break;
		}
		case 3: { //Drawing
			
			//Change state
			cycles += 204;
			lcd_state = 0;
				
			//H-blank interupt request
			if(!vblank_active) {
				if(stat_cache & 8)
					int_request(INT_STAT);
			}
			break;
		}
	}
	
	stat_cache &= 0xFC;
	if(vblank_active) then stat_cache |= 0x01;
	else stat_cache |= lcd_state;
	buffer_poke(mmap, STAT, buffer_u8, stat_cache);
}