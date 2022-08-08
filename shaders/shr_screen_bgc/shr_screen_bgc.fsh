//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform float texx;
uniform float texy;

uniform int lcdc;

int getpixelx()
{
	float o = 0.0;
	for(int i = 0; i <= 255; i++)
	{
		o += texx;
		if(o >= v_vTexcoord.x)
			return i;
	}
	return -1;
}

int getpixely()
{
	float o = 0.0;
	for(int i = 0; i <= 255; i++)
	{
		o += texy;
		if(o >= v_vTexcoord.y)
			return i;
	}
	return -1;
}

int readvram(int address)
{
	int _y = 0;
	int _x = address - 0x8000;
	
	while(_x >= 1024)
	{
		_y++;
		_x -= 1024;
	}
	
	_x = _x / 4;
	int cn = int(mod(float(address), 4.0));
	
	vec4 color = texture2D(gm_BaseTexture, vec2(float(_x) * texx, float(_y) * texy));
	if(cn == 0)
		return int(color.r * 255.0);
	if(cn == 1)
		return int(color.g * 255.0);
	if(cn == 2)
		return int(color.b * 255.0);
	if(cn == 3)
		return int(color.a * 255.0);
	
	return 0;
}

void main()
{
	//Set up things
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	ivec2 pos = ivec2(getpixelx(), getpixely());
	
	//Get the pointer to the map
	int _mappointer = 0x9800;
	_mappointer += pos.x / 8;
	_mappointer += (pos.y / 8) * 32;
	
	//Get the data in the map
	int _mapdata = readvram(_mappointer);
	
	//Find the tile to draw
	int _tilepointer = 0x8000;
	_tilepointer += _mapdata * 16;
	_tilepointer += int(mod(float(pos.y), 8.0)) * 2;
	
	if(_mapdata < 0x80)
		if(int(mod(float(lcdc) / 16.0, 2.0)) == 0)
			_tilepointer += 0x1000;
	
	int _tiledata1 = readvram(_tilepointer);
	int _tiledata2 = readvram(_tilepointer+1);
	
	int poop = int(mod(float(pos.x), 8.0));
	
	int wh = 0x80;
	
	for(int i = poop; i != 0; i--)
		wh /= 2;
	
	_tiledata1 /= wh;
	_tiledata2 /= wh;
	
	_tiledata1 = int(mod(float(_tiledata1), 2.0));
	_tiledata2 = int(mod(float(_tiledata2), 2.0));
	
	int col = 3;
	if(_tiledata1 == 1)
		col -= 1;
	
	if(_tiledata2 == 1)
		col -= 2;
	
	float fcol = float(col) / 3.0;
	color.r = fcol;
	color.g = fcol;
	color.b = fcol;
	
	gl_FragColor = color;
}