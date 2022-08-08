/*function instructions() {
	
	//"weird" functions
	var nop = new opc(function(){ return "nop"; }, function(){  }, 1, 4);
	var stop = new opc(function(){ return "stop"; }, function(){ show_debug_message(tohex(pc) + " STOP"); }, 1, 4);
	var halt = new opc(function(){ return "halt"; }, function(){ cpu_halted = true; }, 1, 4);
	var di = new opc(function(){ return "di"; }, function(){ 
	ime = false; 
	}, 1, 4);
	var ei = new opc(function(){ return "ei"; }, function(){ 
	ei_active = true; 
	}, 1, 4);
	var empty = new opc(function() { return "inv"; }, function() { show_message(tohex(pc) + " inv"); }, 1, 0);
	var scf = new opc(function() { return "scf"; }, function() { fN = 0; fH = 0; fC = 1; }, 1, 4);
	var ccf = new opc(function() { return "ccf"; }, function() { fN = 0; fH = 0; fC = !fC; }, 1, 4);
	var cpla = new opc(function() { return "cpl"; }, function() { a ^= 0xFF; fN = 1; fH = 1; }, 1, 4);
	var daa = new opc(function() { return "daa"; }, function()	{
		var 
			_cor = 0,
			_sc = false,
			_val = a;
		
		if(fH or (!fN and (_val & 0xF) > 9))
			_cor |= 0x6;

		if(fC or (!fN and _val > 0x99))
		{
		   _cor |= 0x60;
		   _sc = true;
		}

		_val += fN ? -_cor : _cor;
		
		_val &= 0xFF;

		fH =  0;
		fC =  _sc;
		fZ =  _val == 0;

		a = _val;
		
	}, 1, 4);

	//8bit loads
	var ldaa = new opc(function(){ return "ld a, a"; }, function(){ a = a; }, 1, 4);
	var ldab = new opc(function(){ return "ld a, b"; }, function(){ a = b; }, 1, 4);
	var ldac = new opc(function(){ return "ld a, c"; }, function(){ a = c; }, 1, 4);
	var ldad = new opc(function(){ return "ld a, d"; }, function(){ a = d; }, 1, 4);
	var ldae = new opc(function(){ return "ld a, e"; }, function(){ a = e; }, 1, 4);
	var lda_h = new opc(function(){ return "ld a, h"; }, function(){ a = h; }, 1, 4);
	var ldal = new opc(function(){ return "ld a, l"; }, function(){ a = l; }, 1, 4);
	
	var ldba = new opc(function(){ return "ld b, a"; }, function(){ b = a; }, 1, 4);
	var ldbb = new opc(function(){ return "ld b, b"; }, function(){ b = b; }, 1, 4);
	var ldbc = new opc(function(){ return "ld b, c"; }, function(){ b = c; }, 1, 4);
	var ldbd = new opc(function(){ return "ld b, d"; }, function(){ b = d; }, 1, 4);
	var ldbe = new opc(function(){ return "ld b, e"; }, function(){ b = e; }, 1, 4);
	var ldbh = new opc(function(){ return "ld b, h"; }, function(){ b = h; }, 1, 4);
	var ldbl = new opc(function(){ return "ld b, l"; }, function(){ b = l; }, 1, 4);
	
	var ldca = new opc(function(){ return "ld c, a"; }, function(){ c = a; }, 1, 4);
	var ldcb = new opc(function(){ return "ld c, b"; }, function(){ c = b; }, 1, 4);
	var ldcc = new opc(function(){ return "ld c, c"; }, function(){ c = c; }, 1, 4);
	var ldcd = new opc(function(){ return "ld c, d"; }, function(){ c = d; }, 1, 4);
	var ldce = new opc(function(){ return "ld c, e"; }, function(){ c = e; }, 1, 4);
	var ldch = new opc(function(){ return "ld c, h"; }, function(){ c = h; }, 1, 4);
	var ldcl = new opc(function(){ return "ld c, l"; }, function(){ c = l; }, 1, 4);
	
	var ldda = new opc(function(){ return "ld d, a"; }, function(){ d = a; }, 1, 4);
	var lddb = new opc(function(){ return "ld d, b"; }, function(){ d = b; }, 1, 4);
	var lddc = new opc(function(){ return "ld d, c"; }, function(){ d = c; }, 1, 4);
	var lddd = new opc(function(){ return "ld d, d"; }, function(){ d = d; }, 1, 4);
	var ldde = new opc(function(){ return "ld d, e"; }, function(){ d = e; }, 1, 4);
	var lddh = new opc(function(){ return "ld d, h"; }, function(){ d = h; }, 1, 4);
	var lddl = new opc(function(){ return "ld d, l"; }, function(){ d = l; }, 1, 4);
	
	var ldea = new opc(function(){ return "ld e, a"; }, function(){ e = a; }, 1, 4);
	var ldeb = new opc(function(){ return "ld e, b"; }, function(){ e = b; }, 1, 4);
	var ldec = new opc(function(){ return "ld e, c"; }, function(){ e = c; }, 1, 4);
	var lded = new opc(function(){ return "ld e, d"; }, function(){ e = d; }, 1, 4);
	var ldee = new opc(function(){ return "ld e, e"; }, function(){ e = e; }, 1, 4);
	var ldeh = new opc(function(){ return "ld e, h"; }, function(){ e = h; }, 1, 4);
	var ldel = new opc(function(){ return "ld e, l"; }, function(){ e = l; }, 1, 4);
	
	var ldha = new opc(function(){ return "ld h, a"; }, function(){ h = a; }, 1, 4);
	var ldhb = new opc(function(){ return "ld h, b"; }, function(){ h = b; }, 1, 4);
	var ldhc = new opc(function(){ return "ld h, c"; }, function(){ h = c; }, 1, 4);
	var ldhd = new opc(function(){ return "ld h, d"; }, function(){ h = d; }, 1, 4);
	var ldhe = new opc(function(){ return "ld h, e"; }, function(){ h = e; }, 1, 4);
	var ldhh = new opc(function(){ return "ld h, h"; }, function(){ h = h; }, 1, 4);
	var ldhl = new opc(function(){ return "ld h, l"; }, function(){ h = l; }, 1, 4);
	
	var ldla = new opc(function(){ return "ld l, a"; }, function(){ l = a; }, 1, 4);
	var ldlb = new opc(function(){ return "ld l, b"; }, function(){ l = b; }, 1, 4);
	var ldlc = new opc(function(){ return "ld l, c"; }, function(){ l = c; }, 1, 4);
	var ldld = new opc(function(){ return "ld l, d"; }, function(){ l = d; }, 1, 4);
	var ldle = new opc(function(){ return "ld l, e"; }, function(){ l = e; }, 1, 4);
	var ldlh = new opc(function(){ return "ld l, h"; }, function(){ l = h; }, 1, 4);
	var ldll = new opc(function(){ return "ld l, l"; }, function(){ l = l; }, 1, 4);

	//read from [HL]
	var ldahl = new opc(function(){ return "ld a, [hl]"; }, function(){ a = mmap_read(hl); }, 1, 8);
	var ldbhl = new opc(function(){ return "ld b, [hl]"; }, function(){ b = mmap_read(hl); }, 1, 8);
	var ldchl = new opc(function(){ return "ld c, [hl]"; }, function(){ c = mmap_read(hl); }, 1, 8);
	var lddhl = new opc(function(){ return "ld d, [hl]"; }, function(){ d = mmap_read(hl); }, 1, 8);
	var ldehl = new opc(function(){ return "ld e, [hl]"; }, function(){ e = mmap_read(hl); }, 1, 8);
	var ldhhl = new opc(function(){ return "ld h, [hl]"; }, function(){ h = mmap_read(hl); }, 1, 8);
	var ldlhl = new opc(function(){ return "ld l, [hl]"; }, function(){ l = mmap_read(hl); }, 1, 8);

	//write to [HL]
	var sthla = new opc(function(){ return "ld [hl], a"; }, function(){ mmap_write(hl, a); }, 1, 8);
	var sthlb = new opc(function(){ return "ld [hl], b"; }, function(){ mmap_write(hl, b); }, 1, 8);
	var sthlc = new opc(function(){ return "ld [hl], c"; }, function(){ mmap_write(hl, c); }, 1, 8);
	var sthld = new opc(function(){ return "ld [hl], d"; }, function(){ mmap_write(hl, d); }, 1, 8);
	var sthle = new opc(function(){ return "ld [hl], e"; }, function(){ mmap_write(hl, e); }, 1, 8);
	var sthlh = new opc(function(){ return "ld [hl], h"; }, function(){ mmap_write(hl, h); }, 1, 8);
	var sthll = new opc(function(){ return "ld [hl], l"; }, function(){ mmap_write(hl, l); }, 1, 8);
	
	//Load from oparand
	var ldan8 = new opc(function(){ return "ld a, n8"; }, function(){ a = bytes[1]; }, 2, 12);
	var ldbn8 = new opc(function(){ return "ld b, n8"; }, function(){ b = bytes[1]; }, 2, 12);
	var ldcn8 = new opc(function(){ return "ld c, n8"; }, function(){ c = bytes[1]; }, 2, 12);
	var lddn8 = new opc(function(){ return "ld d, n8"; }, function(){ d = bytes[1]; }, 2, 12);
	var lden8 = new opc(function(){ return "ld e, n8"; }, function(){ e = bytes[1]; }, 2, 12);
	var ldhn8 = new opc(function(){ return "ld h, n8"; }, function(){ h = bytes[1]; }, 2, 12);
	var ldln8 = new opc(function(){ return "ld l, n8"; }, function(){ l = bytes[1]; }, 2, 12);
	var ldhln8 = new opc(function(){ return "ld [hl], n8"; }, function(){ mmap_write(hl, bytes[1]); }, 2, 12);

	//Load A from address
	var ldan16 = new opc(function(){ return "ld a, [n16]"; }, function(){ a = mmap_read(op16); }, 3, 16)
	var ldabc = new opc(function(){ return "ld a, [bc]"; }, function(){ a = mmap_read(bc); }, 1, 8);
	var ldade = new opc(function(){ return "ld a, [de]"; }, function(){ a = mmap_read(de); }, 1, 8);
	var ldi = new opc(function(){ return "ld a, [hl+]"; }, function(){ a = mmap_read(hl); optable[0x23].func(); }, 1, 8);
	var ldd = new opc(function(){ return "ld a, [hl-]"; }, function(){ a = mmap_read(hl); optable[0x2B].func(); }, 1, 8);
	
	//Store A at address
	var stabc = new opc(function(){ return "ld [bc], a"; }, function(){ mmap_write(bc, a); }, 1, 8);
	var stade = new opc(function(){ return "ld [de], a"; }, function(){ mmap_write(de, a); }, 1, 8);
	var sti = new opc(function(){ return "ld [hl+], a"; }, function(){ mmap_write(hl, a); optable[0x23].func(); }, 1, 8);
	var std = new opc(function(){ return "ld [hl-], a"; }, function(){ mmap_write(hl, a); optable[0x2B].func(); }, 1, 8);
	var stan16 = new opc(function(){ return "ld [n16], a"; }, function(){ mmap_write(op16, a); }, 3, 16);
	
	//Load to and from hram
	var ldah = new opc(function(){ return "ldh a, [$FF00+n8]"; }, function(){ a = mmap_read(0xFF00 + bytes[1]); }, 2, 12);
	var ldahc = new opc(function(){ return "ldh a, [$FF00+c]"; }, function(){ a = mmap_read(0xFF00 + c); }, 1, 8);
	var stah = new opc(function(){ return "ldh [$FF00+n8], a"; }, function(){ mmap_write(0xFF00+bytes[1], a); }, 2, 12);
	var stahc = new opc(function(){ return "ldh [$FF00+c], a"; }, function(){ mmap_write(0xFF00+c, a); }, 1, 8);
	
	//16bit loads
	var ldbcn16 = new opc(function(){ return "ld bc, n16"; }, function(){ c = bytes[1]; b = bytes[2]; }, 3, 12);
	var ldden16 = new opc(function(){ return "ld de, n16"; }, function(){ e = bytes[1]; d = bytes[2]; }, 3, 12);
	var ldhln16 = new opc(function(){ return "ld hl, n16"; }, function(){ l = bytes[1]; h = bytes[2]; }, 3, 12);
	var ldspn16 = new opc(function(){ return "ld sp, n16"; }, function(){ sp = op16; }, 3, 12);
	
	
	var adda = new opc(function(){ return "add a"; }, function(){ add8(a); }, 1, 4);
	var addb = new opc(function(){ return "add b"; }, function(){ add8(b); }, 1, 4);
	var addc = new opc(function(){ return "add c"; }, function(){ add8(c); }, 1, 4);
	var addd = new opc(function(){ return "add d"; }, function(){ add8(d); }, 1, 4);
	var adde = new opc(function(){ return "add e"; }, function(){ add8(e); }, 1, 4);
	var addh = new opc(function(){ return "add h"; }, function(){ add8(h); }, 1, 4);
	var addl = new opc(function(){ return "add l"; }, function(){ add8(l); }, 1, 4);
	var addhlp = new opc(function(){ return "add [hl]"; }, function(){ add8(mmap_read(hl)); }, 1, 8);
	
	//Addition with carry
	var adca = new opc(function(){ return "adc a"; }, function(){ adc8(a); }, 1, 4);
	var adcb = new opc(function(){ return "adc b"; }, function(){ adc8(b); }, 1, 4);
	var adcc = new opc(function(){ return "adc c"; }, function(){ adc8(c); }, 1, 4);
	var adcd = new opc(function(){ return "adc d"; }, function(){ adc8(d); }, 1, 4);
	var adce = new opc(function(){ return "adc e"; }, function(){ adc8(e); }, 1, 4);
	var adch = new opc(function(){ return "adc h"; }, function(){ adc8(h); }, 1, 4);
	var adcl = new opc(function(){ return "adc l"; }, function(){ adc8(l); }, 1, 4);
	var adchlp = new opc(function(){ return "adc [hl]"; }, function(){ adc8(mmap_read(hl)); }, 1, 8);
	
	var suba = new opc(function(){ return "sub a"; }, function(){ sub8(a); }, 1, 4);
	var subb = new opc(function(){ return "sub b"; }, function(){ sub8(b); }, 1, 4);
	var subc = new opc(function(){ return "sub c"; }, function(){ sub8(c); }, 1, 4);
	var subd = new opc(function(){ return "sub d"; }, function(){ sub8(d); }, 1, 4);
	var sube = new opc(function(){ return "sub e"; }, function(){ sub8(e); }, 1, 4);
	var subh = new opc(function(){ return "sub h"; }, function(){ sub8(h); }, 1, 4);
	var subl = new opc(function(){ return "sub l"; }, function(){ sub8(l); }, 1, 4);
	var subhl = new opc(function(){ return "sub [hl]"; }, function(){ sub8(mmap_read(hl)); }, 1, 8);
	
	//Subtraction with carry
	var sbca = new opc(function(){ return "sbc a"; }, function(){ sbc8(a); }, 1, 4);
	var sbcb = new opc(function(){ return "sbc b"; }, function(){ sbc8(b); }, 1, 4);
	var sbcc = new opc(function(){ return "sbc c"; }, function(){ sbc8(c); }, 1, 4);
	var sbcd = new opc(function(){ return "sbc d"; }, function(){ sbc8(d); }, 1, 4);
	var sbce = new opc(function(){ return "sbc e"; }, function(){ sbc8(e); }, 1, 4);
	var sbch = new opc(function(){ return "sbc h"; }, function(){ sbc8(h); }, 1, 4);
	var sbcl = new opc(function(){ return "sbc l"; }, function(){ sbc8(l); }, 1, 4);
	var sbchl = new opc(function(){ return "sbc [hl]"; }, function(){ sbc8(mmap_read(hl)); }, 1, 8);
	
	//and operations
	var anda = new opc(function(){ return "and a"; }, function(){ a&=a; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andb = new opc(function(){ return "and b"; }, function(){ a&=b; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andc = new opc(function(){ return "and c"; }, function(){ a&=c; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andd = new opc(function(){ return "and d"; }, function(){ a&=d; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var ande = new opc(function(){ return "and e"; }, function(){ a&=e; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andh = new opc(function(){ return "and h"; }, function(){ a&=h; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andl = new opc(function(){ return "and l"; }, function(){ a&=l; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 4);
	var andhl = new opc(function(){ return "and [hl]"; }, function(){ a&=mmap_read(hl); fZ = a==0; fN = 0; fH = 1; fC = 0; }, 1, 8);
	
	//or operations
	var ora = new opc(function(){ return "or a"; }, function(){ a|=a; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var orb = new opc(function(){ return "or b"; }, function(){ a|=b; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var orc = new opc(function(){ return "or c"; }, function(){ a|=c; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var ord_ = new opc(function(){ return "or d"; }, function(){ a|=d; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var ore = new opc(function(){ return "or e"; }, function(){ a|=e; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var orh = new opc(function(){ return "or h"; }, function(){ a|=h; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var orl = new opc(function(){ return "or l"; }, function(){ a|=l; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var orhl = new opc(function(){ return "or [hl]"; }, function(){ a|=mmap_read(hl); fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 8);
	
	//xor operations
	var xora = new opc(function(){ return "xor a"; }, function(){ a^=a; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xorb = new opc(function(){ return "xor b"; }, function(){ a^=b; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xorc = new opc(function(){ return "xor c"; }, function(){ a^=c; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xord = new opc(function(){ return "xor d"; }, function(){ a^=d; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xore = new opc(function(){ return "xor e"; }, function(){ a^=e; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xorh = new opc(function(){ return "xor h"; }, function(){ a^=h; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xorl = new opc(function(){ return "xor l"; }, function(){ a^=l; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 4);
	var xorhl = new opc(function(){ return "xor [hl]"; }, function(){ a^=mmap_read(hl); fZ = a==0; fN = 0; fH = 0; fC = 0; }, 1, 8);
	
	
	var cpa = new opc(function(){ return "cp a"; }, function(){ cp8(a); }, 1, 4);
	var cpb = new opc(function(){ return "cp b"; }, function(){ cp8(b); }, 1, 4);
	var cpc = new opc(function(){ return "cp c"; }, function(){ cp8(c); }, 1, 4);
	var cpd = new opc(function(){ return "cp d"; }, function(){ cp8(d); }, 1, 4);
	var cpe = new opc(function(){ return "cp e"; }, function(){ cp8(e); }, 1, 4);
	var cph = new opc(function(){ return "cp h"; }, function(){ cp8(h); }, 1, 4);
	var cpl = new opc(function(){ return "cp l"; }, function(){ cp8(l); }, 1, 4);
	var cphl = new opc(function(){ return "cp [hl]"; }, function(){ cp8(mmap_read(hl)); }, 1, 8);
	
	//Arithmetic with operands
	var addn8 = new opc(function(){ return "add n8"; }, function(){ add8(bytes[1]); }, 2, 8);
	var adcn8 = new opc(function(){ return "adc n8"; }, function(){ adc8(bytes[1]); }, 2, 8);
	var subn8 = new opc(function(){ return "sub n8"; }, function(){ sub8(bytes[1]); }, 2, 8);
	var sbcn8 = new opc(function(){ return "sbc n8"; }, function(){ sbc8(bytes[1]); }, 2, 8);
	var andn8 = new opc(function(){ return "and n8"; }, function(){ a&=bytes[1]; fZ = a==0; fN = 0; fH = 1; fC = 0; }, 2, 8);
	var orn8 = new opc(function(){ return "or n8"; }, function(){ a|=bytes[1]; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 2, 8);
	var xorn8 = new opc(function(){ return "xor n8"; }, function(){ a^=bytes[1]; fZ = a==0; fN = 0; fH = 0; fC = 0; }, 2, 8);
	var cpn8 = new opc(function(){ return "cp n8"; }, function(){ cp8(bytes[1]); }, 2, 8);
	
	
	var addbc = new opc(function(){ return "add bc"; }, function() { add16(bc); }, 1, 8);
	var addde = new opc(function(){ return "add de"; }, function() { add16(de); }, 1, 8);
	var addhl = new opc(function(){ return "add hl"; }, function() { add16(hl); }, 1, 8);
	var addsp = new opc(function(){ return "add sp"; }, function() { add16(sp) }, 1, 8);
	var addspe8 = new opc(function(){ return "add sp, e8"; }, function()
	{
		fZ = 0;
		fN = 0;
		fC = (sp&0xFF) + bytes[1] > 0xFF;
		fH = (sp&0x0F) + (bytes[1]&0x0F) > 0x0F;
		
		sp = (sp + sign8(bytes[1])) & 0xFFFF;
	}, 2, 16);
	
	
	
	//Stack functions
	var pushbc = new opc(function(){ return "push bc"; }, function(){ stack_push(bc); }, 1, 16);
	var pushde = new opc(function(){ return "push de"; }, function(){ stack_push(de); }, 1, 16);
	var pushhl = new opc(function(){ return "push hl"; }, function(){ stack_push(hl) }, 1, 16);
	var pushaf = new opc(function(){ return "push af"; }, function(){ stack_push(af); }, 1, 16);
	var popbc = new opc(function(){ return "pop bc"; }, function(){ c = mmap_read(sp); b = mmap_read((sp+1) &0xFFFF); sp = (sp+2) &0xFFFF; }, 1, 12);
	var popde = new opc(function(){ return "pop de"; }, function(){ e = mmap_read(sp); d = mmap_read((sp+1) &0xFFFF); sp = (sp+2) &0xFFFF; }, 1, 12);
	var pophl = new opc(function(){ return "pop hl"; }, function(){ l = mmap_read(sp); h = mmap_read((sp+1) &0xFFFF); sp = (sp+2) &0xFFFF; }, 1, 12);
	var popaf = new opc(function(){ return "pop af"; }, function()
	{ 
		var _f = mmap_read(sp)&0xF0;
		fZ = _f & 0x80 != 0;
		fN = _f & 0x40 != 0;
		fH = _f & 0x20 != 0;
		fC = _f & 0x10 != 0;
		
		a = mmap_read((sp+1) &0xFFFF); 
		sp = (sp+2) &0xFFFF; 
	}, 1, 12);
	
	//What even are these lol
	var ldsphl = new opc(function(){ return "ld sp, hl"; }, function(){ sp = hl; }, 1, 8);
	var ldn16sp = new opc(function(){ return "ld [n16], sp"; }, function(){mmap_write(op16, sp&0x00FF); mmap_write(op16+1, (sp>>8)&0x00FF); }, 3, 20);
	var ldhlspe8 = new opc(function(){ return "ld hl, sp+e8"; }, function()
	{
		fZ =  0;
		fN =  0;
		fC =  (sp&0xFF) + bytes[1] > 0xFF;
		fH =  (sp&0x0F) + (bytes[1]&0x0F) > 0x0F;
		
		var _res = (sp + sign8(bytes[1])) & 0xFFFF;
		h = (_res>>8) & 0xFF;
		l = _res & 0xFF;
	}, 2, 12);
	


	//Increment
	var inca = new opc(function(){ return "inc a"; }, function(){ a = inc8(a); }, 1, 4);
	var incb = new opc(function(){ return "inc b"; }, function(){ b = inc8(b); }, 1, 4);
	var incc = new opc(function(){ return "inc c"; }, function(){ c = inc8(c); }, 1, 4);
	var incd = new opc(function(){ return "inc d"; }, function(){ d = inc8(d); }, 1, 4);
	var ince = new opc(function(){ return "inc e"; }, function(){ e = inc8(e) }, 1, 4);
	var inch = new opc(function(){ return "inc h"; }, function(){ h = inc8(h); }, 1, 4);
	var incl = new opc(function(){ return "inc l"; }, function(){ l = inc8(l); }, 1, 4);
	var inchlp = new opc(function(){ return "inc [hl]"; }, function(){ mmap_write(hl, inc8(mmap_read(hl))); }, 1, 12);

	var incbc = new opc(function(){ return "inc bc"; }, function(){ c = ++c&0xFF; b = (b + (c == 0)) &0xFF; }, 1, 8);
	var incde = new opc(function(){ return "inc de"; }, function(){ e = ++e&0xFF; d = (d + (e == 0)) &0xFF; }, 1, 8);
	var inchl = new opc(function(){ return "inc hl"; }, function(){ l = ++l&0xFF; h = (h + (l == 0)) &0xFF; }, 1, 8);
	var incsp = new opc(function(){ return "inc sp"; }, function(){ sp = ++sp & 0xFFFF; }, 1, 8);

	//Decrement
	var deca = new opc(function(){ return "dec a"; }, function(){ a = dec8(a); }, 1, 4);
	var decb = new opc(function(){ return "dec b"; }, function(){ b = dec8(b); }, 1, 4);
	var decc = new opc(function(){ return "dec c"; }, function(){ c = dec8(c); }, 1, 4);
	var decd = new opc(function(){ return "dec d"; }, function(){ d = dec8(d); }, 1, 4);
	var dece = new opc(function(){ return "dec e"; }, function(){ e = dec8(e); }, 1, 4);
	var dech = new opc(function(){ return "dec h"; }, function(){ h = dec8(h); }, 1, 4);
	var decl = new opc(function(){ return "dec l"; }, function(){ l = dec8(l); }, 1, 4);
	var dechlp = new opc(function(){ return "dec [hl]"; }, function(){ mmap_write(hl, dec8(mmap_read(hl))); }, 1, 12);

	var decbc = new opc(function(){ return "dec bc"; }, function(){ --c; if(c == -1) then c = 0xFF; b = (b - (c == 0xFF)) &0xFF; }, 1, 8);
	var decde = new opc(function(){ return "dec de"; }, function(){ --e; if(e == -1) then e = 0xFF; d = (d - (e == 0xFF)) &0xFF; }, 1, 8);
	var dechl = new opc(function(){ return "dec hl"; }, function(){ --l; if(l == -1) then l = 0xFF; h = (h - (l == 0xFF)) &0xFF; }, 1, 8);
	var decsp = new opc(function(){ return "dec sp"; }, function(){ sp = --sp % 0x10000; }, 1, 8);


	//Global jumps
	var jp = new opc(function(){ return "jp n16"; }, function(){ cpu_jump(op16); }, 3, 16);
	var jphl = new opc(function(){ return "jp hl"; }, function(){ cpu_jump(hl); }, 1, 4);
	var jpz = new opc(function(){ return "jp z, n16"; }, function(){ opcode.cycles = 12; if(fZ) { cpu_jump(op16); opcode.cycles = 16; } }, 3, 0);
	var jpnz = new opc(function(){ return "jp nz, n16"; }, function(){ opcode.cycles = 12; if(!fZ) { cpu_jump(op16); opcode.cycles = 16; } }, 3, 0);
	var jpc = new opc(function(){ return "jp c, n16"; }, function(){ opcode.cycles = 12; if(fC) { cpu_jump(op16); opcode.cycles = 16; } }, 3, 0);
	var jpnc = new opc(function(){ return "jp nc, n16"; }, function(){ opcode.cycles = 12; if(!fC) { cpu_jump(op16); opcode.cycles = 16; } }, 3, 0);
	
	//Local jumps
	var jr = new opc(function(){ return "jr e8"; }, function(){ cpu_jump(pc + sign8(bytes[1])); }, 2, 12);
	var jrz = new opc(function(){ return "jr z, e8"; }, function(){ opcode.cycles = 8; if(fZ) { cpu_jump(pc + sign8(bytes[1])); opcode.cycles = 12; } }, 2, 0);
	var jrnz = new opc(function(){ return "jr nz, e8"; }, function(){ opcode.cycles = 8; if(!fZ) { cpu_jump(pc + sign8(bytes[1])); opcode.cycles = 12; } }, 2, 0);
	var jrc = new opc(function(){ return "jr c, e8"; }, function(){ opcode.cycles = 8; if(fC) { cpu_jump(pc + sign8(bytes[1])); opcode.cycles = 12; } }, 2, 0);
	var jrnc = new opc(function(){ return "jr nc, e8"; }, function(){ opcode.cycles = 8; if(!fC) { cpu_jump(pc + sign8(bytes[1])); opcode.cycles = 12; } }, 2, 0);
	
	//Calls
	var call = new opc(function(){ return "call n16"; }, function(){ stack_push(pc); cpu_jump(op16); }, 3, 24);
	var callz = new opc(function(){ return "call z, n16"; }, function(){ opcode.cycles = 12; if(fZ) { stack_push(pc); cpu_jump(op16); opcode.cycles = 24; } }, 3, 0);
	var callnz = new opc(function(){ return "call nz, n16"; }, function(){ opcode.cycles = 12; if(!fZ) { stack_push(pc); cpu_jump(op16); opcode.cycles = 24; } }, 3, 0);
	var callc = new opc(function(){ return "call c, n16"; }, function(){ opcode.cycles = 12; if(fC) { stack_push(pc); cpu_jump(op16); opcode.cycles = 24; } }, 3, 0);
	var callnc = new opc(function(){ return "call nc, n16"; }, function(){ opcode.cycles = 12; if(!fC) { stack_push(pc); cpu_jump(op16); opcode.cycles = 24; } }, 3, 0);
	
	var ret = new opc(function(){ return "ret"; }, function()
	{
		pc = mmap_read((sp+1) & 0xFFFF) << 8;
		pc += mmap_read(sp);
		sp = (sp+2) & 0xFFFF;
		buffer_seek(mmap, buffer_seek_start, pc);
	}, 1, 16);
	var reti = new opc(function(){ return "reti"; }, function(){ 
		optable[0xC9].func(); ime = true; 
	}, 1, 16);
	var retz = new opc(function(){ return "ret z"; }, function(){ opcode.cycles = 8; if(fZ) { optable[0xC9].func(); opcode.cycles = 20; } }, 1, 0);
	var retnz = new opc(function(){ return "ret nz"; }, function(){ opcode.cycles = 8; if(!fZ) { optable[0xC9].func(); opcode.cycles = 20; } }, 1, 0);
	var retc = new opc(function(){ return "ret c"; }, function(){ opcode.cycles = 8; if(fC) { optable[0xC9].func(); opcode.cycles = 20; } }, 1, 0);
	var retnc = new opc(function(){ return "ret nc"; }, function(){ opcode.cycles = 8; if(!fC) { optable[0xC9].func(); opcode.cycles = 20; } }, 1, 0);
	
	//Reset calls
	var rst00 = new opc(function(){ return "rst $0000"; }, function(){ stack_push(pc); cpu_jump(0x0000); }, 1, 16);
	var rst10 = new opc(function(){ return "rst $0010"; }, function(){ stack_push(pc); cpu_jump(0x0010); }, 1, 16);
	var rst20 = new opc(function(){ return "rst $0020"; }, function(){ stack_push(pc); cpu_jump(0x0020); }, 1, 16);
	var rst30 = new opc(function(){ return "rst $0030"; }, function(){ stack_push(pc); cpu_jump(0x0030); }, 1, 16);
	var rst08 = new opc(function(){ return "rst $0008"; }, function(){ stack_push(pc); cpu_jump(0x0008); }, 1, 16);
	var rst18 = new opc(function(){ return "rst $0018"; }, function(){ stack_push(pc); cpu_jump(0x0018); }, 1, 16);
	var rst28 = new opc(function(){ return "rst $0028"; }, function(){ stack_push(pc); cpu_jump(0x0028); }, 1, 16);
	var rst38 = new opc(function(){ return "rst $0038"; }, function(){ stack_push(pc); cpu_jump(0x0038); }, 1, 16);
	
	//Bitwise arithmetic functions
	var rla = new opc(function(){ return "rla"; }, function(){ var _p = (a&1<<7)>>7; a=(a<<1)&0xFF; a|=fC; fC = _p; fZ = 0; fH = 0; fN = 0; }, 1, 4);
	var rra = new opc(function(){ return "rra"; }, function(){ var _p = a&1; a=(a>>1)&0xFF; a|=fC<<7; fC = _p; fZ = 0; fH = 0; fN = 0; }, 1, 4);
	var rrca = new opc(function(){ return "rrca"; }, function(){ fC = a&1; fZ = 0; fH = 0; fN = 0; a=(a>>1)&0xFF; a|=fC<<7; }, 1, 4);
	var rlca = new opc(function(){ return "rlca"; }, function(){ fC = (a&1<<7)>>7; fZ = 0; fH = 0; fN = 0; a=(a<<1)&0xFF; a|=fC; }, 1, 4);
	var prefix = new opc(function() { return optable_bitwise[bytes[1]].name(); }, function(){ optable_bitwise[bytes[1]].func(); }, 2, 0);
	
	//Populate optable
	optable = [
	
		nop,  ldbcn16, stabc, incbc, incb,   decb,  ldbn8,   rlca,  ldn16sp, addbc,  ldabc, decbc,  incc, decc, ldcn8, rrca,
		stop, ldden16, stade, incde, incd,   decd,  lddn8,   rla,   jr,       addde,  ldade, decde,  ince, dece, lden8, rra,
		jrnz, ldhln16,  sti,    inchl, inch,    dech,  ldhn8,   daa, jrz,       addhl,  ldi,    dechl,   incl,  decl,  ldln8, cpla,
		jrnc, ldspn16, std,    incsp, inchlp, dechlp, ldhln8,  scf,  jrc,       addsp,  ldd,   decsp,  inca,  deca, ldan8, ccf,

		ldbb,  ldbc, ldbd,  ldbe,   ldbh, ldbl,  ldbhl, ldba,  ldcb, ldcc, ldcd,  ldce, ldch,   ldcl, ldchl, ldca, 
		lddb,  lddc, lddd,  ldde,   lddh, lddl,  lddhl, ldda,  ldeb, ldec, lded,  ldee, ldeh,   ldel, ldehl, ldea, 
		ldhb,  ldhc, ldhd,  ldhe,   ldhh, ldhl,  ldhhl, ldha,  ldlb,  ldlc,  ldld,  ldle,  ldlh,   ldll,  ldlhl, ldla, 
		sthlb, sthlc, sthld, sthle,  sthlh, sthll, halt,  sthla, ldab, ldac, ldad, ldae, lda_h, ldal, ldahl, ldaa,

		addb, addc, addd,  adde, addh, addl, addhlp, adda, adcb, adcc, adcd, adce, adch, adcl, adchlp,  adca,
		subb, subc,  subd,  sube, subh, subl,  subhl,  suba,  sbcb, sbcc, sbcd, sbce,  sbch, sbcl, sbchl,  sbca,
		andb, andc,  andd, ande, andh, andl,  andhl,  anda,  xorb, xorc, xord, xore,  xorh, xorl, xorhl,  xora,
		orb,   orc,   ord_,  ore,  orh,   orl,   orhl,   ora,   cpb,   cpc,  cpd,  cpe,   cph,  cpl,   cphl,   cpa,

		retnz, popbc,  jpnz,  jp,      callnz, pushbc,  addn8, rst00,  retz,     ret,    jpz,      prefix,  callz,    call,   adcn8, rst08, 
		retnc, popde,  jpnc,  empty, callnc, pushde,  subn8,  rst10,  retc,     reti,   jpc,      empty,  callc,   empty, sbcn8, rst18, 
		stah,  pophl,  stahc, empty, empty, pushhl,  andn8,  rst20,  addspe8, jphl,   stan16,  empty,  empty, empty, xorn8, rst28, 
		ldah,  popaf,  ldahc, di,      empty, pushaf, orn8,    rst30,  ldhlspe8, ldsphl, ldan16,  ei,      empty, empty,  cpn8,  rst38
	];
}