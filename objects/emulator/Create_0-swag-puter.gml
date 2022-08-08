//Debug thing
halt = false;
text = "";

room_speed = 30;
holdtimer = 0;

//Registers :)
a = 0;
f = 0;
b = 0;
c = 0;
d = 0;
e = 0;
h = 0;
l = 0;
sp = 0xFFFF;
pc = 0x100;

cycles = 0;
opcode = 0;

//Memory map
mmap = buffer_create(0x10000, buffer_fast, 1);
bytes = array_create(6);

instructions();

//optable
optable = [ 0x100];
#macro inv empty

optable = 
[
nop, ldbcn16, stabc, incbc, incb, decb, ldbn8, inv, ldn16sp, inv, ldabc, decbc, incc, decc, ldcn8, inv,
stop, ldden16, stade, incde, incd, decd, lddn8, inv, jr, inv, ldade, decde, ince, dece, lden8, inv,
jrnz, ldhln16, sti, inchl, inch, dech, ldhn8, inv, jrz, inv, ldi, dechl, incl, decl, ldln8, inv,
jrnc, ldspn16, std, incsp, inchlp, dechlp, ldhln8, scf, jrc, inv, ldd, decsp, inca, deca, ldan8, ccf,

ldbb, ldbc, ldbd, ldbe, ldbh, ldbl, ldbhl, ldba, ldcb, ldcc, ldcd, ldce, ldch, ldcl, ldchl, ldca, 
lddb, lddc, lddd, ldde, lddh, lddl, lddhl, ldda, ldeb, ldec, lded, ldee, ldeh, ldel, ldehl, ldea, 
ldhb, ldhc, ldhd, ldhe, ldhh, ldhl, ldhhl, ldha, ldlb, ldlc, ldld, ldle, ldlh, ldll, ldlhl, ldla, 
sthlb, sthlc, sthld, sthle, sthlh, sthll, halt, sthla, ldab, ldac, ldad, ldae, ldah, ldal, ldahl, ldaa,

inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, 
inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, 
inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, 
inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, inv, 

inv, popbc, jpnz, jp, inv, pushbc, inv, inv, inv, inv, jpz, inv, inv, inv, inv, inv, 
inv, popde, jpnc, empty, inv, pushde, inv, inv,  inv, inv, jpc, empty, inv, empty, inv, inv, 
stah, pophl, stahc, empty, empty, pushhl, inv, inv, inv, jphl, stan16, empty, empty, empty, inv, inv, 
ldah, popaf, ldahc, di, empty, pushaf, inv, inv, ldhlspe8, ldsphl, ldan16, ei, empty, empty, inv, inv
];

//Bus structure
bus = 
{
	rom0_b : 0x0000,
	rom0_e : 0x3FFF,
	romx_b : 0x4000,
	romx_e : 0x7FFF,
	
	vram_b : 0x8000,
	vram_e : 0x9FFF,
	
	sram_b : 0xA000,
	sram_e : 0xBFFF,
	wram_b : 0xC000,
	wram_e : 0xDFFF,
	eram_b : 0xE000,
	eram_e : 0xFDFF,
	
	oam_b : 0xFE00,
	oam_e : 0xFE9F,
	
	fexx_b : 0xFEA0,
	fexx_e : 0xFEFF,
	
	io_b : 0xFF00,
	io_e : 0xFF7F,
	
	hram_b : 0xFF80,
	hram_e : 0xFFFE,
	
	interupt_flag : 0xFFFF,
	
	read : function(_address)
	{
		var _res = buffer_peek(emu.mmap, _address, buffer_u8);
		return(_res);
	},
	
	write : function(_address, _byte)
	{
		buffer_poke(emu.mmap, _address, buffer_u8, _byte);
	},
};

//Read the ROM
rom_file = get_open_filename("","");
rom = file_bin_open(rom_file, 0);
buffer_seek(mmap, buffer_seek_start, 0);
for(var i = 0; i <= 0x7FFF; i++)
{
	buffer_write(mmap, buffer_u8, file_bin_read_byte(rom));
}

buffer_seek(mmap, buffer_seek_start, pc);