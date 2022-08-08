function timer_init() {
	//TAC states
	tac_states = [1024, 16, 64, 256];
	
	//TAC cache, for speed :)
	tac_cache = 0;
	
	timer_reset();
}

function timer_reset() {
	timer_add = 0;
	div_inc = 0;
}

function timer_run() {
	//DIV register
	div_inc += cycles_c;
	if(div_inc > 255) {
		div_inc -= 256;
		buffer_poke(mmap, DIV, buffer_u8, buffer_peek(mmap, DIV, buffer_u8)+1&0xFF);
	}
	
	//If timer is active
	if!(tac_cache & 4)
		return;
	
	//Add to the timer-counter
	timer_add += cycles_c;
		
	//If timer counter reaches its goal
	var _goal = tac_states[tac_cache & 3];
	if(timer_add < _goal) then return;
		
	//Increase timer
	timer_add = 0;
	var _tima = buffer_peek(mmap, TIMA, buffer_u8);
	_tima++;
			
	//If timer overflows
	if(_tima == 256) {
			
		//Reset timer & request timer interupt
		_tima = buffer_peek(mmap, TMA, buffer_u8);
		int_request(INT_TIMER);
	}
			
	//Write the timer back
	buffer_poke(mmap, TIMA, buffer_u8, _tima);
}