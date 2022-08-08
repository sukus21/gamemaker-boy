//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform float texx;
uniform float texy;

uniform int ignoreRegs;

ivec2 pos;
int lcdc;
int bgp;

int getpixelx() {
	float o = 0.0;
	for(int i = 0; i <= 255; i++)	{
		o += texx;
		if(o >= v_vTexcoord.x)
			return i;
	}
	return -1;
}

int getpixely() {
	float o = 0.0;
	for(int i = 0; i <= 255; i++) {
		o += texy;
		if(o >= v_vTexcoord.y)
			return i;
	}
	return -1;
}

int readvram(int address) {
	int _x = address - 0x8000;
	
	_x = _x / 4;
	int cn = int(mod(float(address), 4.0));
	
	//Grab data
	vec4 color;
	if(ignoreRegs == 0)
		color = texture2D(gm_BaseTexture, vec2(float(_x) * texx, float(pos.y) * texy));
	else
		color = texture2D(gm_BaseTexture, vec2(float(_x) * texx, texy));
	
	//Sort data
	if(cn == 0)
		return int(color.r * 255.0);
	if(cn == 1)
		return int(color.g * 255.0);
	if(cn == 2)
		return int(color.b * 255.0);
	if(cn == 3)
		return int(color.a * 255.0);
	
	//Worst case, return 0
	return 0;
}

int readreg(int regid) {
	
	if(ignoreRegs == 0) {
		int _x = regid / 4;
		int cn = int(mod(float(regid), 4.0));
	
		vec4 color = texture2D(gm_BaseTexture, vec2((float(_x) * texx) + 0.5, (float(pos.y) * texy) + 0.5));
	
		if(cn == 0)
			return int(color.r * 255.0);
		if(cn == 1)
			return int(color.g * 255.0);
		if(cn == 2)
			return int(color.b * 255.0);
		if(cn == 3)
			return int(color.a * 255.0);
	}
	else {
		
		//LCDC
		if(regid == 0) {
			
			int ret = 1;
			int _x = regid / 4;
			int val = int(texture2D(gm_BaseTexture, vec2((float(_x) * texx) + 0.5, 0.5)).r * 255.0);
			if(val >= 128)
				val -= 128;
			if(val >= 64)
				val -= 64;
			if(val >= 32)
				val -= 32;
			
			if(val >= 16)
				ret += 16;
			
			if(ignoreRegs == 2)
				ret += 8;
			
			return ret;
		}
		
		//BGP
		if(regid == 3)
			return 0xE4;
		
		//Anything else
		return 0x00;
	}
	return 0;
}

ivec4 readoam(int spriteid) {
	vec4 color = texture2D(gm_BaseTexture, vec2((float(spriteid) * texx), (float(pos.y) * texy) + 0.5));
	return ivec4(int(color.r * 255.0), int(color.g * 255.0), int(color.b * 255.0), int(color.a * 255.0));
}

vec4 fetch_bg() {
	
	//Scroll :)
	ivec2 pix = ivec2(pos.x + readreg(2), pos.y + readreg(1));
	if(pix.x > 255)
		pix.x -= 256;
	if(pix.y > 255)
		pix.y -= 256;
	
	//Get the pointer to the map
	int _mappointer = 0x9800;
	if(mod(float(lcdc / 8), 2.0) == 1.0)
		_mappointer += 0x0400;
	
	_mappointer += pix.x / 8;
	_mappointer += (pix.y / 8) * 32;
	
	//Get the data in the map
	int _mapdata = readvram(_mappointer);
	
	//Find the tile to draw
	int _tilepointer = 0x8000;
	_tilepointer += _mapdata * 16;
	_tilepointer += int(mod(float(pix.y), 8.0)) * 2;
	
	if(_mapdata < 0x80)
	{
		if(int(mod(float(lcdc) / 16.0, 2.0)) == 0) {
			_tilepointer += 0x1000;
		}
	}
	
	int _tiledata1 = readvram(_tilepointer);
	int _tiledata2 = readvram(_tilepointer+1);
	
	int poop = int(mod(float(pix.x), 8.0));
	
	int wh = 0x80;
	
	for(int i = poop; i != 0; i--)
		wh /= 2;
	
	_tiledata1 /= wh;
	_tiledata2 /= wh;
	
	_tiledata1 = int(mod(float(_tiledata1), 2.0));
	_tiledata2 = int(mod(float(_tiledata2), 2.0));
	
	int bg_pal = 0;
	if(_tiledata1 == 1)
		bg_pal += 2;
	
	if(_tiledata2 == 1)
		bg_pal += 4;
	
	int bg_col = 3-int(mod(float(bgp / (int(pow(2.0, float(bg_pal))))), 4.0));
	
	float fcol = float(bg_col) / 3.0;
	return vec4(fcol, fcol, fcol, float(bg_pal) / 3.0);
}

vec4 fetch_win() {
	if(mod(float(lcdc / 32), 2.0) == 0.0)
		return vec4(0.0, 0.0, 0.0, 0.0);
	
	int _wx = readreg(7)-7;
	int _wy = readreg(6);
	if(pos.x < _wx || pos.y < _wy)
		return vec4(0.0, 0.0, 0.0, 0.0);
	
	//Scroll :)
	ivec2 pix = ivec2(pos.x - _wx, pos.y - _wy);
	if(pix.x > 255)
		pix.x -= 256;
	if(pix.y > 255)
		pix.y -= 256;
	
	//Get the pointer to the map
	int _mappointer = 0x9800;
	if(mod(float(lcdc / 64), 2.0) == 1.0)
		_mappointer += 0x0400;
	
	_mappointer += pix.x / 8;
	_mappointer += (pix.y / 8) * 32;
	
	//Get the data in the map
	int _mapdata = readvram(_mappointer);
	
	//Find the tile to draw
	int _tilepointer = 0x8000;
	_tilepointer += _mapdata * 16;
	_tilepointer += int(mod(float(pix.y), 8.0)) * 2;
	
	if(_mapdata < 0x80) {
		if(int(mod(float(lcdc) / 16.0, 2.0)) == 0) {
			_tilepointer += 0x1000;
		}
	}
	
	int _tiledata1 = readvram(_tilepointer);
	int _tiledata2 = readvram(_tilepointer+1);
	
	int poop = int(mod(float(pix.x), 8.0));
	
	int wh = 0x80;
	
	for(int i = poop; i != 0; i--)
		wh /= 2;
	
	_tiledata1 /= wh;
	_tiledata2 /= wh;
	
	_tiledata1 = int(mod(float(_tiledata1), 2.0));
	_tiledata2 = int(mod(float(_tiledata2), 2.0));
	
	int bg_pal = 0;
	if(_tiledata1 == 1)
		bg_pal += 2;
	
	if(_tiledata2 == 1)
		bg_pal += 4;
	
	int bg_col = 3-int(mod(float(bgp / (int(pow(2.0, float(bg_pal))))), 4.0));
	
	float fcol = float(bg_col) / 3.0;
	return vec4(fcol, fcol, 1.0, 1.0+float(bg_pal) / 3.0);
}

vec4 fetch_obj(float _bg)
{
	//If sprites are disabled
	if(mod(float(lcdc / 2), 2.0) == 0.0)
		return vec4(0.0, 0.0, 0.0, 0.0);
	
	//Get object palettes
	int obp0 = readreg(4);
	int obp1 = readreg(5);
	
	//Get sprite size (8*8 / 8*16)
	int sprh = int(mod(float(lcdc / 4), 2.0)) * 8 + 8;
	
	//Loop for each sprite
	for(int i = 39; i >= 0; i--)
	{
		ivec4 sprite = readoam(i);
		sprite.r -= 16;
		sprite.g -= 8;
		
		int _resx = pos.x - sprite.g;
		int _resy = pos.y - sprite.r;
		if(_resy < sprh && _resy >= 0 && _resx < 8 && _resx >= 0)
		{
			if(sprite.a / 128 == 1 && _bg != 0.0)
				continue;
			
			//return vec4(1.0, 0.0, 0.0, 1.0);
			if(sprh == 16)
				sprite.b = (sprite.b / 2) * 2;
			
			int _tilepointer = 0x8000;
			_tilepointer += sprite.b * 16;
			
			if(mod(float(sprite.a / 64), 2.0) == 0.0)
				_tilepointer += _resy * 2;
			else {
				_tilepointer += 14;
				_tilepointer -= _resy * 2;
				
				if(sprh == 16) {
					if(_resx > 7)
						_tilepointer -= 16;
					else
						_tilepointer += 16;
				}
			}
			
			int _tiledata1 = readvram(_tilepointer);
			int _tiledata2 = readvram(_tilepointer+1);
			
			int wh;
			if(mod(float(sprite.a / 32), 2.0) == 0.0) {
				wh = 0x80;
				for(int i = _resx; i != 0; i--)
					wh /= 2;
			}
			else {
				wh = 0x01;
				for(int i = _resx; i != 0; i--)
					wh *= 2;
			}
			_tiledata1 /= wh;
			_tiledata2 /= wh;
			_tiledata1 = int(mod(float(_tiledata1), 2.0));
			_tiledata2 = int(mod(float(_tiledata2), 2.0));
			
			int obj_pal = 0;
			if(_tiledata1 == 1)
				obj_pal += 2;
	
			if(_tiledata2 == 1)
				obj_pal += 4;
			
			
	
			if(obj_pal != 0)
			{
				int obp;
				if(mod(float(sprite.a / 16), 2.0) == 0.0)
					obp = obp0;
				else
					obp = obp1;
			
				//float fcol;
				int obj_col = 3-int(mod(float(obp / (int(pow(2.0, float(obj_pal))))), 4.0));
				
				float fcol = float(obj_col) / 3.0;
				return vec4(fcol, fcol, fcol, 1.0);
			}
		}
	}
	
	return vec4(0.0, 0.0, 0.0, 0.0);
}

void main() {
	//Break if outside 256x256 area
	if(v_vTexcoord.x > 0.125 || v_vTexcoord.y > 0.5)
		discard;
	
	//Set up things
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	pos = ivec2(getpixelx(), getpixely());
	lcdc = readreg(0);
	bgp = readreg(3);
	
	//Fetch BG and OBJ color
	vec4 bgcolor = fetch_bg();
	vec4 wincolor = fetch_win();
	
	//Win takes priority over bg
	if(wincolor.b == 1.0) {
		bgcolor = wincolor;
		bgcolor.b = bgcolor.r;
	}
	
	vec4 objcolor = fetch_obj(bgcolor.a);
	
	//Make OBJ take priority
	if(objcolor.a == 1.0)
		color = objcolor;
	else
		color.rgb = bgcolor.rgb;
	
	color.a = 1.0;
	
	//Draw red lines indicating the edges of the GB screen
	if(pos.x == 160  && ignoreRegs == 0 || pos.y == 144 && ignoreRegs == 0)
		color = vec4(1.0, 0.0, 0.0, 1.0);
	
	//Draw :)
	gl_FragColor = color;
}