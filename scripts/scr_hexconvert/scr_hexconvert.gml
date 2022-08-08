function tohex(_number) {
	var _result = "";
	
	while(true)
	{
		if(_number == 0) then break;
		var _c;
		switch(_number & 0x000F)
		{
			case 0: _c = "0"; break;
			case 1: _c = "1"; break;
			case 2: _c = "2"; break;
			case 3: _c = "3"; break;
			case 4: _c = "4"; break;
			case 5: _c = "5"; break;
			case 6: _c = "6"; break;
			case 7: _c = "7"; break;
			case 8: _c = "8"; break;
			case 9: _c = "9"; break;
			case 10: _c = "A"; break;
			case 11: _c = "B"; break;
			case 12: _c = "C"; break;
			case 13: _c = "D"; break;
			case 14: _c = "E"; break;
			case 15: _c = "F"; break;
			default: _c = "X"; break;
		}
		_number = _number >> 4;
		_result = _c + _result;
	}
	
	if(_result == "") then _result = "0";
	if(string_length(_result) % 2) then _result = "0" + _result;
	return _result;
}

function tohex_pad(_number, _mindigits) {
	var _result = tohex(_number);
	while(string_length(_result) < _mindigits) _result = "0" + _result;
	return _result;
}

function todec(_input) {
	var 
		_res = 0,
		_c = 0;
	for(var i = string_length(_input); i > 0; i--)
	{
		var 
			_char = string_char_at(_input, i),
			_d = 0;
		switch(_char)
		{
			case "0": _d = 0; break;
			case "1": _d = 1; break;
			case "2": _d = 2; break;
			case "3": _d = 3; break;
			case "4": _d = 4; break;
			case "5": _d = 5; break;
			case "6": _d = 6; break;
			case "7": _d = 7; break;
			case "8": _d = 8; break;
			case "9": _d = 9; break;
			case "A": _d = 10; break;
			case "B": _d = 11; break;
			case "C": _d = 12; break;
			case "D": _d = 13; break;
			case "E": _d = 14; break;
			case "F": _d = 15; break;
			default: show_message("Oopsie poopsie"); break;
		}
		
		_res += _d << _c;
		_c += 4;
	}
	
	return _res;
}