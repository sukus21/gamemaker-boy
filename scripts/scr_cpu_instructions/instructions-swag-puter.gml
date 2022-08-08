function instructions()
{	
	//Opcode constructor
	function opc(_name, _func, _bytes, _cycles) constructor
	{
		func = _func;
		size = _bytes;
		cycles = _cycles;
		name = _name;
	}

	//"weird" functions
	nop = new opc("nop", fu{  }, 1, 4);
	stop = new opc("stop", fu{  }, 1, 4);
	halt = new opc("halt", fu{  }, 1, 4);
	di = new opc("di", fu{  }, 1, 4);
	ei = new opc("ei", fu{  }, 1, 4);
	empty = new opc("invalid", fu{ show_message("Invalid opcode, what do? :("); }, 0, 0);
	scf = new opc("scf", fu{ flag(N,0); flag(H,0); flag(C,1); }, 1, 4);
	ccf = new opc("ccf", fu{ flag(N,0); flag(H,0); flag(C,!sign(f&1<<C)); }, 1, 4);

	//8bit loads
	{
	ldaa = new opc("ld a, a", fu{ a = a; }, 1, 4);
	ldab = new opc("ld a, b", fu{ a = b; }, 1, 4);
	ldac = new opc("ld a, c", fu{ a = c; }, 1, 4);
	ldad = new opc("ld a, d", fu{ a = d; }, 1, 4);
	ldae = new opc("ld a, e", fu{ a = e; }, 1, 4);
	ldah = new opc("ld a, h", fu{ a = h; }, 1, 4);
	ldal = new opc("ld a, l", fu{ a = l; }, 1, 4);
	
	ldba = new opc("ld b, a", fu{ b = a; }, 1, 4);
	ldbb = new opc("ld b, b", fu{ b = b; }, 1, 4);
	ldbc = new opc("ld b, c", fu{ b = c; }, 1, 4);
	ldbd = new opc("ld b, d", fu{ b = d; }, 1, 4);
	ldbe = new opc("ld b, e", fu{ b = e; }, 1, 4);
	ldbh = new opc("ld b, h", fu{ b = h; }, 1, 4);
	ldbl = new opc("ld b, l", fu{ b = l; }, 1, 4);
	
	ldca = new opc("ld c, a", fu{ c = a; }, 1, 4);
	ldcb = new opc("ld c, b", fu{ c = b; }, 1, 4);
	ldcc = new opc("ld c, c", fu{ c = c; }, 1, 4);
	ldcd = new opc("ld c, d", fu{ c = d; }, 1, 4);
	ldce = new opc("ld c, e", fu{ c = e; }, 1, 4);
	ldch = new opc("ld c, h", fu{ c = h; }, 1, 4);
	ldcl = new opc("ld c, l", fu{ c = l; }, 1, 4);
	
	ldda = new opc("ld d, a", fu{ d = a; }, 1, 4);
	lddb = new opc("ld d, b", fu{ d = b; }, 1, 4);
	lddc = new opc("ld d, c", fu{ d = c; }, 1, 4);
	lddd = new opc("ld d, d", fu{ d = d; }, 1, 4);
	ldde = new opc("ld d, e", fu{ d = e; }, 1, 4);
	lddh = new opc("ld d, h", fu{ d = h; }, 1, 4);
	lddl = new opc("ld d, l", fu{ d = l; }, 1, 4);
	
	ldea = new opc("ld e, a", fu{ e = a; }, 1, 4);
	ldeb = new opc("ld e, b", fu{ e = b; }, 1, 4);
	ldec = new opc("ld e, c", fu{ e = c; }, 1, 4);
	lded = new opc("ld e, d", fu{ e = d; }, 1, 4);
	ldee = new opc("ld e, e", fu{ e = e; }, 1, 4);
	ldeh = new opc("ld e, h", fu{ e = h; }, 1, 4);
	ldel = new opc("ld eh l", fu{ e = l; }, 1, 4);
	
	ldha = new opc("ld h, a", fu{ h = a; }, 1, 4);
	ldhb = new opc("ld h, b", fu{ h = b; }, 1, 4);
	ldhc = new opc("ld h, c", fu{ h = c; }, 1, 4);
	ldhd = new opc("ld h, d", fu{ h = d; }, 1, 4);
	ldhe = new opc("ld h, e", fu{ h = e; }, 1, 4);
	ldhh = new opc("ld h, h", fu{ h = h; }, 1, 4);
	ldhl = new opc("ld h, l", fu{ h = l; }, 1, 4);
	
	ldla = new opc("ld l, a", fu{ l = a; }, 1, 4);
	ldlb = new opc("ld l, b", fu{ l = b; }, 1, 4);
	ldlc = new opc("ld l, c", fu{ l = c; }, 1, 4);
	ldld = new opc("ld l, d", fu{ l = d; }, 1, 4);
	ldle = new opc("ld l, e", fu{ l = e; }, 1, 4);
	ldlh = new opc("ld l, h", fu{ l = h; }, 1, 4);
	ldll = new opc("ld l, l", fu{ l = l; }, 1, 4);

	//read from [HL]
	ldahl = new opc("ld a, [hl]", fu{ a = bus.read(hl); }, 1, 8);
	ldbhl = new opc("ld b, [hl]", fu{ b = bus.read(hl); }, 1, 8);
	ldchl = new opc("ld c, [hl]", fu{ c = bus.read(hl); }, 1, 8);
	lddhl = new opc("ld d, [hl]", fu{ d = bus.read(hl); }, 1, 8);
	ldehl = new opc("ld e, [hl]", fu{ e = bus.read(hl); }, 1, 8);
	ldhhl = new opc("ld h, [hl]", fu{ h = bus.read(hl); }, 1, 8);
	ldlhl = new opc("ld l, [hl]", fu{ l = bus.read(hl); }, 1, 8);

	//write to [HL]
	sthla = new opc("ld [hl], a", fu{ bus.write(hl, a); }, 1, 8);
	sthlb = new opc("ld [hl], b", fu{ bus.write(hl, b); }, 1, 8);
	sthlc = new opc("ld [hl], c", fu{ bus.write(hl, c); }, 1, 8);
	sthld = new opc("ld [hl], d", fu{ bus.write(hl, d); }, 1, 8);
	sthle = new opc("ld [hl], e", fu{ bus.write(hl, e); }, 1, 8);
	sthlh = new opc("ld [hl], h", fu{ bus.write(hl, h); }, 1, 8);
	sthll = new opc("ld [hl], l", fu{ bus.write(hl, l); }, 1, 8);
	
	//Load from oparand
	ldan8 = new opc("ld a, n8", fu{ a = bytes[1]; }, 2, 8);
	ldbn8 = new opc("ld b, n8", fu{ b = bytes[1]; }, 2, 8);
	ldcn8 = new opc("ld c, n8", fu{ c = bytes[1]; }, 2, 8);
	lddn8 = new opc("ld d, n8", fu{ d = bytes[1]; }, 2, 8);
	lden8 = new opc("ld e, n8", fu{ e = bytes[1]; }, 2, 8);
	ldhn8 = new opc("ld h, n8", fu{ h = bytes[1]; }, 2, 8);
	ldln8 = new opc("ld l, n8", fu{ l = bytes[1]; }, 2, 8);
	ldhln8 = new opc("ld [hl], n8", fu{ bus.write(hl, bytes[1]); }, 2, 12);

	//Load A from address
	ldan16 = new opc("ld a, [n16]", fu{ a = bus.read(op16); }, 3, 16)
	ldabc = new opc("ld a, [bc]", fu{ a = bus.read(bc); }, 1, 8);
	ldade = new opc("ld a, [de]", fu{ a = bus.read(de); }, 1, 8);
	ldi = new opc("ld a, [hl+]", fu{ a = bus.read(hl); inchl.func(); }, 1, 8);
	ldd = new opc("ld a, [hl-]", fu{ a = bus.read(hl); dechl.func(); }, 1, 8);
	
	//Store A at address
	stabc = new opc("ld [bc], a", fu{ bus.write(bc, a); }, 1, 8);
	stade = new opc("ld [de], a", fu{ bus.write(de, a); }, 1, 8);
	sti = new opc("ld [hl+], a", fu{ bus.write(hl, a); inchl.func(); }, 1, 8);
	std = new opc("ld [hl-], a", fu{ bus.write(hl, a); inchl.func(); }, 1, 8);
	
	//Various special cases
	ldah = new opc("ldh a, [$FF00+n8]", fu{ a = bus.read(0xFF00 + bytes[1]); }, 2, 12);
	ldahc = new opc("ldh a, [$FF00+c]", fu{ a = bus.read(0xFF00 + c); }, 1, 8);
	stah = new opc("ldh [$FF00+n8], a", fu{ bus.write(0xFF00+bytes[1], a); }, 2, 12);
	stahc = new opc("ldh [$FF00+c], a", fu{ bus.write(0xFF00+c, a); }, 1, 8);
	stan16 = new opc("ld [n16], a", fu{ bus.write(op16, a); }, 3, 16);
	}
	
	//16bit loads
	ldbcn16 = new opc("ld bc, n16", fu{ c = bytes[1]; b = bytes[2]; }, 3, 12);
	ldden16 = new opc("ld de, n16", fu{ e = bytes[1]; d = bytes[2]; }, 3, 12);
	ldhln16 = new opc("ld hl, n16", fu{ l = bytes[1]; h = bytes[2]; }, 3, 12);
	ldspn16 = new opc("ld sp, n16", fu{ sp = op16; }, 3, 12);
	
	//Stack functions
	pushbc = new opc("push bc", fu{ sp -= 2; if(sp < 0) then sp += 0x10000; bus.write((sp+1)%0x10000, b); bus.write(sp, c); }, 1, 16);
	pushde = new opc("push de", fu{ sp -= 2; if(sp < 0) then sp += 0x10000; bus.write((sp+1)%0x10000, d); bus.write(sp, e); }, 1, 16);
	pushhl = new opc("push hl", fu{ sp -= 2; if(sp < 0) then sp += 0x10000; bus.write((sp+1)%0x10000, h); bus.write(sp, l); }, 1, 16);
	pushaf = new opc("push af", fu{ sp -= 2; if(sp < 0) then sp += 0x10000; bus.write((sp+1)%0x10000, a); bus.write(sp, f); }, 1, 16);
	popbc = new opc("pop bc", fu{ c = bus.read(sp); b = bus.read((sp+1) % 0x10000); sp = (sp+2) % 0x10000 }, 1, 12);
	popde = new opc("pop de", fu{ e = bus.read(sp); d = bus.read((sp+1) % 0x10000); sp = (sp+2) % 0x10000 }, 1, 12);
	pophl = new opc("pop hl", fu{ l = bus.read(sp); h = bus.read((sp+1) % 0x10000); sp = (sp+2) % 0x10000 }, 1, 12);
	popaf = new opc("pop af", fu{ f = bus.read(sp); a = bus.read((sp+1) % 0x10000); sp = (sp+2) % 0x10000 }, 1, 12);
	
	ldsphl = new opc("ld sp, hl", fu{ sp = hl; }, 1, 8);
	ldhlspe8 = new opc("ld hl, sp+e8", fu
	{
		var _offset;
		if(bytes[1]&(1<<7)) then _offset = -(-bytes[1] + 255)-1; else _offset = bytes[1];
		l = sp&0x00FF;
		h = (sp>>8)&0x00FF;
		var _p = l, _p2 = h;
		l += _offset;
		if(l > 255) { l -= 255; h++; }
		if(l < 0) { l += 255; h--; }
		
		flag(Z, 0);
		flag(N, 0);
		flag(H, (l&1<<4) and !(_p&1<<4));
		flag(C, h != _p2);
	}, 2, 12);
	
	//what even is this one
	ldn16sp = new opc("ld [n16], sp", fu{bus.write(op16, sp&0x00FF); bus.write(op16, (sp>>8)&0x00FF); }, 3, 20);
	


	//Increment
	inca = new opc("inc a", fu{ var _p = a; a = ++a % 256; flags_inc(a, _p); }, 1, 4);
	incb = new opc("inc b", fu{ var _p = b; b = ++b % 256; flags_inc(b, _p); }, 1, 4);
	incc = new opc("inc c", fu{ var _p = c; c = ++c % 256; flags_inc(c, _p); }, 1, 4);
	incd = new opc("inc d", fu{ var _p = d; d = ++d % 256; flags_inc(d, _p); }, 1, 4);
	ince = new opc("inc e", fu{ var _p = e; e = ++e % 256; flags_inc(e, _p); }, 1, 4);
	inch = new opc("inc h", fu{ var _p = h; h = ++h % 256; flags_inc(h, _p); }, 1, 4);
	incl = new opc("inc l", fu{ var _p = l; l = ++l % 256; flags_inc(l, _p); }, 1, 4);
	inchlp = new opc("inc [hl]", fu{ var _p = bus.read(hl); bus.write(hl, ++bus.read(hl) % 256); flags_inc(bus.read(hl), _p); }, 1, 12);

	incbc = new opc("inc bc", fu{ c = ++c % 256; b = (b + (c == 0) % 256); }, 1, 8);
	incde = new opc("inc de", fu{ e = ++e % 256; d = (d + (e == 0) % 256); }, 1, 8);
	inchl = new opc("inc hl", fu{ l = ++l % 256; h = (h + (l == 0) % 256); }, 1, 8);
	incsp = new opc("inc sp", fu{ sp = ++sp % 0x10000; }, 1, 8);

	//Decrement
	deca = new opc("dec a", fu{ var _p = a; --a; if(a == -1) then a = 255; flags_dec(a, _p); }, 1, 4);
	decb = new opc("dec b", fu{ var _p = b; --b; if(b == -1) then b = 255; flags_dec(b, _p); }, 1, 4);
	decc = new opc("dec c", fu{ var _p = c; --c; if(c == -1) then c = 255; flags_dec(c, _p); }, 1, 4);
	decd = new opc("dec d", fu{ var _p = d; --d; if(d == -1) then d = 255; flags_dec(d, _p); }, 1, 4);
	dece = new opc("dec e", fu{ var _p = e; --e; if(e == -1) then e = 255; flags_dec(e, _p); }, 1, 4);
	dech = new opc("dec h", fu{ var _p = h; --h; if(h == -1) then h = 255; flags_dec(h, _p); }, 1, 4);
	decl = new opc("dec l", fu{ var _p = l; --l; if(l == -1) then l = 255; flags_dec(l, _p); }, 1, 4);
	dechlp = new opc("dec [hl]", fu{ var _p = bus.read(hl); --bus.read(hl); if(bus.read(hl) == -1) then bus.write(hl, 255); flags_dec(bus.read(hl), _p); }, 1, 12);

	decbc = new opc("dec bc", fu{ --c; if(c == -1) then c = 255; b = (b + (c == 255) % 256); }, 1, 8);
	decde = new opc("dec de", fu{ --e; if(e == -1) then e = 255; d = (d + (e == 255) % 256); }, 1, 8);
	dechl = new opc("dec hl", fu{ --l; if(l == -1) then l = 255; h = (h + (l == 255) % 256); }, 1, 8);
	decsp = new opc("dec sp", fu{ sp = --sp % 0x10000; }, 1, 8);




	#region Jumps
	jp = new opc("jp n16", fu{ pc = op16; buffer_seek(mmap, buffer_seek_start, pc); }, 3, 16);
	jphl = new opc("jp hl", fu{ pc = hl; buffer_seek(mmap, buffer_seek_start, pc); }, 1, 4);
	jpz = new opc("jp z, n16", fu{ opcode.cycles = 12; if(f&1<<Z) { jp.func(); opcode.cycles = 16; } }, 3, 0);
	jpnz = new opc("jp nz, n16", fu{ opcode.cycles = 12; if!(f&1<<Z) { jp.func(); opcode.cycles = 16; } }, 3, 0);
	jpc = new opc("jp c, n16", fu{ opcode.cycles = 12; if(f&1<<C) { jp.func(); opcode.cycles = 16; } }, 3, 0);
	jpnc = new opc("jp nc, n16", fu{ opcode.cycles = 12; if!(f&1<<C) { jp.func(); opcode.cycles = 16; } }, 3, 0);
	
	
	jr = new opc("jr e8", fu
	{
		var _offset;
		if(bytes[1]&(1<<7)) then _offset = -(-bytes[1] + 255)-1; else _offset = bytes[1];
		pc = (pc + _offset) % 0x10000;
		buffer_seek(mmap, buffer_seek_start, pc); 
	}, 2, 12);
	jrz = new opc("jr z, e8", fu{ opcode.cycles = 8; if(f&1<<Z) { jr.func(); opcode.cycles = 12; } }, 2, 0);
	jrnz = new opc("jr nz, e8", fu{ opcode.cycles = 8; if!(f&1<<Z) { jr.func(); opcode.cycles = 12; } }, 2, 0);
	jrc = new opc("jr c, e8", fu{ opcode.cycles = 8; if(f&1<<C) { jr.func(); opcode.cycles = 12; } }, 2, 0);
	jrnc = new opc("jr nc, e8", fu{ opcode.cycles = 8; if!(f&1<<C) { jr.func(); opcode.cycles = 12; } }, 2, 0);
	#endregion
}