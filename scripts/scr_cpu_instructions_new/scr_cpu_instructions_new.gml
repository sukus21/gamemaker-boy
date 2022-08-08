function scr_cpu_instructions_new() {

	//Macros
	#macro hl_read		buffer_peek(mmap, hl, buffer_u8)
	#macro hl_write	mmap_write(hl, hlw);
	#macro YYC:oppointer	((buffer_read(mmap, buffer_u8) << 8) + (buffer_read(mmap, buffer_u8)))
	#macro Default:oppointer	((buffer_read(mmap, buffer_u8)) + (buffer_read(mmap, buffer_u8) << 8))
	#macro hl_inc		var _hl = hl + 1; l = _hl & 0xFF; _hl = _hl >> 8; h = _hl & 0xFF
	#macro hl_dec		var _hl = hl - 1; l = _hl & 0xFF; _hl = _hl >> 8; h = _hl & 0xFF
	#macro sign_8		mv = (mv & 0x80) ? -((mv ^ 0xFF) + 1) : mv;
	
#region "Weird" functions
	
	var inv = function() { show_message("INV at " + tohex(buffer_tell(mmap))); };
	var nop = function() { };
	var stop = function() { 
		justgo = false; 
		show_message("STOP at " + tohex(buffer_tell(mmap)));
	};
	
	var halt = function() { cpu_halted = true; };
	var di = function() { ime = false; };
	var ei = function() { ei_active = true; };
	
	var scf = function() {
		fN = false;
		fH = false;
		fC = true;
	};
	
	var ccf = function() {
		fN = false;
		fH = false;
		fC = !fC;
	};
	
	var cpl = function() {
		a ^= 0xFF;
		fN = true;
		fH = true;
	}
	
	var daa = function() {
		var _cor = 0;
		var _sc = false;
		var _val = a;
		
		if(fH or (!fN and (_val & 0xF) > 9))
			_cor |= 0x6;

		if(fC or (!fN and _val > 0x99)) {
		   _cor |= 0x60;
		   _sc = true;
		}

		_val += fN ? -_cor : _cor;
		
		_val &= 0xFF;

		fH =  0;
		fC =  _sc;
		fZ =  _val == 0;

		a = _val;
	}
	
#endregion
#region 8-bit loads
	
	//8bit loads
	var ld_aa = function() { a = a; };
	var ld_ab = function() { a = b; };
	var ld_ac = function() { a = c; };
	var ld_ad = function() { a = d; };
	var ld_ae = function() { a = e; };
	var ld_ah = function() { a = h; };
	var ld_al = function() { a = l; };
	
	var ld_ba = function() { b = a; };
	var ld_bb = function() { b = b; };
	var ld_bc = function() { b = c; };
	var ld_bd = function() { b = d; };
	var ld_be = function() { b = e; };
	var ld_bh = function() { b = h; };
	var ld_bl = function() { b = l; };
	
	var ld_ca = function() { c = a; };
	var ld_cb = function() { c = b; };
	var ld_cc = function() { c = c; };
	var ld_cd = function() { c = d; };
	var ld_ce = function() { c = e; };
	var ld_ch = function() { c = h; };
	var ld_cl = function() { c = l; };
	
	var ld_da = function() { d = a; };
	var ld_db = function() { d = b; };
	var ld_dc = function() { d = c; };
	var ld_dd = function() { d = d; };
	var ld_de = function() { d = e; };
	var ld_dh = function() { d = h; };
	var ld_dl = function() { d = l; };
	
	var ld_ea = function() { e = a; };
	var ld_eb = function() { e = b; };
	var ld_ec = function() { e = c; };
	var ld_ed = function() { e = d; };
	var ld_ee = function() { e = e; };
	var ld_eh = function() { e = h; };
	var ld_el = function() { e = l; };
	
	var ld_ha = function() { h = a; };
	var ld_hb = function() { h = b; };
	var ld_hc = function() { h = c; };
	var ld_hd = function() { h = d; };
	var ld_he = function() { h = e; };
	var ld_hh = function() { h = h; };
	var ld_hl = function() { h = l; };
	
	var ld_la = function() { l = a; };
	var ld_lb = function() { l = b; };
	var ld_lc = function() { l = c; };
	var ld_ld = function() { l = d; };
	var ld_le = function() { l = e; };
	var ld_lh = function() { l = h; };
	var ld_ll = function() { l = l; };
	
#endregion
#region [HL] loads
	
	var ld_ahl = function() { a = hl_read; };
	var ld_bhl = function() { b = hl_read; };
	var ld_chl = function() { c = hl_read; };
	var ld_dhl = function() { d = hl_read; };
	var ld_ehl = function() { e = hl_read; };
	var ld_hhl = function() { h = hl_read; };
	var ld_lhl = function() { l = hl_read; };
	
	var ld_hla = function() { var hlw = a; hl_write; };
	var ld_hlb = function() { var hlw = b; hl_write; };
	var ld_hlc = function() { var hlw = c; hl_write; };
	var ld_hld = function() { var hlw = d; hl_write; };
	var ld_hle = function() { var hlw = e; hl_write; };
	var ld_hlh = function() { var hlw = h; hl_write; };
	var ld_hll = function() { var hlw = l; hl_write; };
	
#endregion
#region Oparand loads
	
	var ld_an = function() { a = buffer_read(mmap, buffer_u8); };
	var ld_bn = function() { b = buffer_read(mmap, buffer_u8); };
	var ld_cn = function() { c = buffer_read(mmap, buffer_u8); };
	var ld_dn = function() { d = buffer_read(mmap, buffer_u8); };
	var ld_en = function() { e = buffer_read(mmap, buffer_u8); };
	var ld_hn = function() { h = buffer_read(mmap, buffer_u8); };
	var ld_ln = function() { l = buffer_read(mmap, buffer_u8); };
	var ld_hlpn=function() { var hlw = buffer_read(mmap, buffer_u8); hl_write; };
	
#endregion
#region Special A loads
	
	var ld_ap =   function() { a = buffer_peek(mmap, oppointer, buffer_u8); };
	var ld_abc =  function() { a = buffer_peek(mmap, bc, buffer_u8); };
	var ld_ade =  function() { a = buffer_peek(mmap, de, buffer_u8); };
	var ldi_ahl = function() { a = hl_read; hl_inc };
	var ldd_ahl = function() { a = hl_read; hl_dec };
	
	var ld_pa =   function() { mmap_write(oppointer, a); };
	var ld_bca =  function() { mmap_write(bc, a); };
	var ld_dea =  function() { mmap_write(de, a); };
	var ldi_hla = function() { var hlw = a; hl_write; hl_inc; };
	var ldd_hla = function() { var hlw = a; hl_write; hl_dec; };
	
#endregion
#region High loads

	var ldh_an = function() { a = buffer_peek(mmap, 0xFF00 + buffer_read(mmap, buffer_u8), buffer_u8); };
	var ldh_ac = function() { a = buffer_peek(mmap, 0xFF00 + c, buffer_u8); };
	var ldh_na = function() { mmap_write(0xFF00 + buffer_read(mmap, buffer_u8), a); };
	var ldh_ca = function() { mmap_write(0xFF00 + c, a); };

#endregion
#region 16-bit loads

	var ld_bcn = function() { c = buffer_read(mmap, buffer_u8); b = buffer_read(mmap, buffer_u8); };
	var ld_den = function() { e = buffer_read(mmap, buffer_u8); d = buffer_read(mmap, buffer_u8); };
	var ld_hln = function() { l = buffer_read(mmap, buffer_u8); h = buffer_read(mmap, buffer_u8); };
	var ld_spn = function() { sp = oppointer; };

#endregion

#region Arithmatic
	
	//Addition
	#macro add_8 fN = 0; fH = (((mv&0x0F) + (a&0x0F)) & 0x10) == 0x10; fC = (mv + a) > 0xFF; a = (a + mv) & 0xFF; fZ = a == 0
	var add_a = function() { var mv = a; add_8; };
	var add_b = function() { var mv = b; add_8; };
	var add_c = function() { var mv = c; add_8; };
	var add_d = function() { var mv = d; add_8; };
	var add_e = function() { var mv = e; add_8; };
	var add_h = function() { var mv = h; add_8; };
	var add_l = function() { var mv = l; add_8; };
	var add_hl= function() { var mv = hl_read; add_8; };
	var add_n = function() { var mv = buffer_read(mmap, buffer_u8); add_8; };
	
	//Addition with carry
	#macro adc_8 fN = 0;	fH = (((mv&0x0F) + (a&0x0F) + fC) & 0x10) == 0x10;	a += fC;	fC = (a + mv) > 0xFF; a = (a + mv) & 0xFF; fZ = a == 0
	var adc_a = function() { var mv = a; adc_8; };
	var adc_b = function() { var mv = b; adc_8; };
	var adc_c = function() { var mv = c; adc_8; };
	var adc_d = function() { var mv = d; adc_8; };
	var adc_e = function() { var mv = e; adc_8; };
	var adc_h = function() { var mv = h; adc_8; };
	var adc_l = function() { var mv = l; adc_8; };
	var adc_hl= function() { var mv = hl_read; adc_8; };
	var adc_n = function() { var mv = buffer_read(mmap, buffer_u8); adc_8; };
	
	//Subtraction
	#macro sub_8 fN = 1;	fH = ((a&0x0F) - (mv&0x0F)) < 0;	fC = mv > a; a = a - mv & 0xFF; fZ = a == 0
	var sub_a = function() { var mv = a; sub_8; };
	var sub_b = function() { var mv = b; sub_8; };
	var sub_c = function() { var mv = c; sub_8; };
	var sub_d = function() { var mv = d; sub_8; };
	var sub_e = function() { var mv = e; sub_8; };
	var sub_h = function() { var mv = h; sub_8; };
	var sub_l = function() { var mv = l; sub_8; };
	var sub_hl= function() { var mv = hl_read; sub_8; };
	var sub_n = function() { var mv = buffer_read(mmap, buffer_u8); sub_8; };
	
	//Subtraction with carry
	#macro sbc_8 fN = 1; fH = ((a&0x0F) - (mv&0x0F) - fC) < 0; mv += fC;	fC = mv > a; a = a - mv & 0xFF; fZ = a == 0
	var sbc_a = function() { var mv = a; sbc_8; };
	var sbc_b = function() { var mv = b; sbc_8; };
	var sbc_c = function() { var mv = c; sbc_8; };
	var sbc_d = function() { var mv = d; sbc_8; };
	var sbc_e = function() { var mv = e; sbc_8; };
	var sbc_h = function() { var mv = h; sbc_8; };
	var sbc_l = function() { var mv = l; sbc_8; };
	var sbc_hl= function() { var mv = hl_read; sbc_8; };
	var sbc_n = function() { var mv = buffer_read(mmap, buffer_u8); sbc_8; };
	

#endregion
#region 16-bit addition

	#macro add_16 var _res = hl + mv; fC = _res > 0xFFFF; fN = 0; fH = ((mv&0x0FFF) + (hl&0x0FFF)) & 0x1000 == 0x1000; h = (_res >> 8) & 0xFF; l = _res & 0xFF;
	var adw_bc = function() { var mv = bc; add_16; };
	var adw_de = function() { var mv = de; add_16; };
	var adw_hl = function() { var mv = hl; add_16; };
	var adw_sp = function() { var mv = sp; add_16; };

#endregion
#region Bitwise logic

	//Logical AND
	#macro and_8 a&=mv; fZ = a==0; fN = 0; fH = 1; fC = 0;
	var and_a = function() { var mv = a; and_8; };
	var and_b = function() { var mv = b; and_8; };
	var and_c = function() { var mv = c; and_8; };
	var and_d = function() { var mv = d; and_8; };
	var and_e = function() { var mv = e; and_8; };
	var and_h = function() { var mv = h; and_8; };
	var and_l = function() { var mv = l; and_8; };
	var and_hl= function() { var mv = hl_read; and_8; };
	var and_n = function() { var mv = buffer_read(mmap, buffer_u8); and_8; };
	
	//Logical OR
	#macro or_8 a|=mv; fZ = a==0; fN = 0; fH = 0; fC = 0;
	var or_a = function() { var mv = a; or_8; };
	var or_b = function() { var mv = b; or_8; };
	var or_c = function() { var mv = c; or_8; };
	var or_d = function() { var mv = d; or_8; };
	var or_e = function() { var mv = e; or_8; };
	var or_h = function() { var mv = h; or_8; };
	var or_l = function() { var mv = l; or_8; };
	var or_hl= function() { var mv = hl_read; or_8; };
	var or_n = function() { var mv = buffer_read(mmap, buffer_u8); or_8; };
	
	//Logical XOR
	#macro xor_8 a^=mv; fZ = a==0; fN = 0; fH = 0; fC = 0;
	var xor_a = function() { var mv = a; xor_8; };
	var xor_b = function() { var mv = b; xor_8; };
	var xor_c = function() { var mv = c; xor_8; };
	var xor_d = function() { var mv = d; xor_8; };
	var xor_e = function() { var mv = e; xor_8; };
	var xor_h = function() { var mv = h; xor_8; };
	var xor_l = function() { var mv = l; xor_8; };
	var xor_hl= function() { var mv = hl_read; xor_8; };
	var xor_n = function() { var mv = buffer_read(mmap, buffer_u8); xor_8; };
	
	//Subtraction with discarded result
	#macro cp_8  fN = 1;	fH = ((a&0x0F) - (mv&0x0F)) < 0;	fC = mv > a; fZ = a - mv == 0
	var cp_a = function() { var mv = a; cp_8; };
	var cp_b = function() { var mv = b; cp_8; };
	var cp_c = function() { var mv = c; cp_8; };
	var cp_d = function() { var mv = d; cp_8; };
	var cp_e = function() { var mv = e; cp_8; };
	var cp_h = function() { var mv = h; cp_8; };
	var cp_l = function() { var mv = l; cp_8; };
	var cp_hl= function() { var mv = hl_read; cp_8; };
	var cp_n = function() { var mv = buffer_read(mmap, buffer_u8); cp_8; };

#endregion
#region Decrements and Increments

	//Increment 8-bit
	#macro inc_8 mv = ++mv & 0xFF; fZ = mv == 0; fN = 0; fH = mv & 0x0F == 0;
	var inc_a = function() { var mv = a; inc_8; a = mv; };
	var inc_b = function() { var mv = b; inc_8; b = mv; };
	var inc_c = function() { var mv = c; inc_8; c = mv; };
	var inc_d = function() { var mv = d; inc_8; d = mv; };
	var inc_e = function() { var mv = e; inc_8; e = mv; };
	var inc_h = function() { var mv = h; inc_8; h = mv; };
	var inc_l = function() { var mv = l; inc_8; l = mv; };
	var inc_hlp=function() { var mv = hl_read; inc_8; var hlw = mv; hl_write; };
	
	//Increment 16 bit
	var inc_bc = function() { var _hl = bc + 1; c = _hl & 0xFF; _hl = _hl >> 8; b = _hl & 0xFF; };
	var inc_de = function() { var _hl = de + 1; e = _hl & 0xFF; _hl = _hl >> 8; d = _hl & 0xFF; };
	var inc_hl = function() { hl_inc; };
	var inc_sp = function() { sp = ++sp & 0xFFFF; };
	
	//Decrement 8-bit
	#macro dec_8 mv = --mv & 0xFF; fZ = mv == 0; fN = 1; fH = mv & 0x0F == 0x0F;
	var dec_a = function() { var mv = a; dec_8; a = mv; };
	var dec_b = function() { var mv = b; dec_8; b = mv; };
	var dec_c = function() { var mv = c; dec_8; c = mv; };
	var dec_d = function() { var mv = d; dec_8; d = mv; };
	var dec_e = function() { var mv = e; dec_8; e = mv; };
	var dec_h = function() { var mv = h; dec_8; h = mv; };
	var dec_l = function() { var mv = l; dec_8; l = mv; };
	var dec_hlp=function() { var mv = hl_read; dec_8; var hlw = mv; hl_write; };
	
	//Decrement 16 bit
	var dec_bc = function() { var _hl = bc - 1; c = _hl & 0xFF; _hl = _hl >> 8; b = _hl & 0xFF; };
	var dec_de = function() { var _hl = de - 1; e = _hl & 0xFF; _hl = _hl >> 8; d = _hl & 0xFF; };
	var dec_hl = function() { hl_dec; };
	var dec_sp = function() { sp = --sp & 0xFFFF; };

#endregion
#region Stack operations
	
	
	//Weird opcodes
	var ld_sphl = function() { sp = hl; };
	var ld_psp  = function() {
		var _p = oppointer;
		mmap_write(_p, sp & 0xFF);
		mmap_write(_p+1, (sp>>8) & 0xFF);
	};
	var ld_hlsp = function() {
		var mv = buffer_read(mmap, buffer_u8);
		sign_8;
		
		fZ = 0;
		fN = 0;
		fC = (sp&0xFF) + mv > 0xFF;
		fH = (sp&0x0F) + (mv&0x0F) > 0x0F;
		
		var _res = (sp + mv) & 0xFFFF;
		h = (_res>>8) & 0xFF;
		l = _res & 0xFF;
	};
	var add_spe = function() {
		var mv = buffer_read(mmap, buffer_u8);
		sign_8;
		
		fZ = 0;
		fN = 0;
		fC = (sp&0xFF) + mv > 0xFF;
		fH = (sp&0x0F) + (mv&0x0F) > 0x0F;
		
		sp = (sp + mv) & 0xFFFF;
	};
	
	//Push functions
	#macro push_16 sp = (sp - 2) & 0xFFFF; mmap_write((sp+1)&0xFFFF, (mv>>8)&0xFF); mmap_write(sp, mv&0xFF)
	var push_bc = function() { var mv = bc; push_16; };
	var push_de = function() { var mv = de; push_16; };
	var push_hl = function() { var mv = hl; push_16; };
	var push_af = function() { var mv = af; push_16; };
	
	//Pop functions
	var pop_bc = function() { c = mmap_read(sp); b = mmap_read((sp+1) & 0xFFFF); sp = (sp+2) & 0xFFFF; };
	var pop_de = function() { e = mmap_read(sp); d = mmap_read((sp+1) & 0xFFFF); sp = (sp+2) & 0xFFFF; };
	var pop_hl = function() { l = mmap_read(sp); h = mmap_read((sp+1) & 0xFFFF); sp = (sp+2) & 0xFFFF; };
	var pop_af = function() {
		var _f = mmap_read(sp) & 0xF0;
		fZ = _f & 0x80 != 0;
		fN = _f & 0x40 != 0;
		fH = _f & 0x20 != 0;
		fC = _f & 0x10 != 0;
		
		a = mmap_read((sp+1) & 0xFFFF); 
		sp = (sp+2) & 0xFFFF;
	};

#endregion

#region Those 4 shift operations

	var rla = function() {
		var _p = a & 0x80;
		a = (a << 1) & 0xFF;
		a |= fC;
		
		fC = _p != 0;
		fZ = 0;
		fH = 0;
		fN = 0;
	};
	var rra = function() {
		var _p = a & 0x01;
		a = (a >> 1) & 0xFF;
		a |= fC << 7;
		
		fC = _p;
		fZ = 0;
		fH = 0;
		fN = 0;
	};
	var rlca = function() {
		fC = a & 0x80 != 0;
		a = (a << 1) & 0xFF;
		a |= fC;
		
		fZ = 0;
		fH = 0;
		fN = 0;
	};
	var rrca = function() {
		fC = a & 0x01 != 0;
		a = (a >> 1) & 0xFF;
		a |= fC << 7;
		
		fZ = 0;
		fH = 0;
		fN = 0;
	};

#endregion
#region Nothing but the prefix in here

	optable_prefixed = scr_cpu_instructions_prefixed();
	var prefix = function() {
		var _subcode = buffer_read(mmap, buffer_u8);
		optable_prefixed[_subcode](_subcode);
	};

#endregion

#region Global jumps

	#macro jp_16 buffer_seek(mmap, buffer_seek_start, mv);
	var jp = function() { var mv = oppointer; jp_16; };
	var jp_hl = function() { var mv = hl; jp_16; };
	
	//Conditional jumps
	var jp_z = function() { var mv = oppointer; if(fZ) {
		jp_16;
		cycles_c += 4;
	}};
	var jp_nz = function() { var mv = oppointer; if(!fZ) {
		jp_16;
		cycles_c += 4;
	}};
	var jp_c = function() { var mv = oppointer; if(fC) {
		jp_16;
		cycles_c += 4;
	}};
	var jp_nc = function() { var mv = oppointer; if(!fC) {
		jp_16;
		cycles_c += 4;
	}};

#endregion
#region Local jumps

	#macro jr_8 buffer_seek(mmap, buffer_seek_relative, mv)
	var jr = function() { var mv = buffer_read(mmap, buffer_u8); sign_8; jr_8; };
	var jr_z = function() { var mv = buffer_read(mmap, buffer_u8); if(fZ) {
		sign_8; jr_8;
		cycles_c += 4;
	}};
	var jr_nz = function() { var mv = buffer_read(mmap, buffer_u8); if(!fZ) {
		sign_8; jr_8;
		cycles_c += 4;
	}};
	var jr_c = function() { var mv = buffer_read(mmap, buffer_u8); if(fC) {
		sign_8; jr_8;
		cycles_c += 4;
	}};
	var jr_nc = function() { var mv = buffer_read(mmap, buffer_u8); if(!fC) {
		sign_8; jr_8;
		cycles_c += 4;
	}};

#endregion
#region Calls

	#macro call_16 var _p = mv; mv = buffer_tell(mmap); push_16; mv = _p; jp_16
	var call = function() { var mv = oppointer; call_16; };
	var call_z = function() { var mv = oppointer; if(fZ) {
		call_16;
		cycles_c += 12;
	}};
	var call_nz = function() { var mv = oppointer; if(!fZ) {
		call_16;
		cycles_c += 12;
	}};
	var call_c = function() { var mv = oppointer; if(fC) {
		call_16;
		cycles_c += 12;
	}};
	var call_nc = function() { var mv = oppointer; if(!fC) {
		call_16;
		cycles_c += 12;
	}};
	
#endregion
#region Returns

	#macro ret_16 buffer_seek(mmap, buffer_seek_start, (mmap_read((sp+1) & 0xFFFF) << 8) + mmap_read(sp)); sp = (sp + 2) & 0xFFFF
	var ret = function() { ret_16; };
	var reti = function() { ret_16; ime = true; };
	var ret_z = function() { if(fZ) {
		ret_16;
		cycles_c += 12;
	}};
	var ret_nz = function() { if(!fZ) {
		ret_16;
		cycles_c += 12;
	}};
	var ret_c = function() { if(fC) {
		ret_16;
		cycles_c += 12;
	}};
	var ret_nc = function() { if(!fC) {
		ret_16;
		cycles_c += 12;
	}};
	
#endregion
#region Reset vectors

	var rst_00 = function() { var mv = 0x0000; call_16; };
	var rst_08 = function() { var mv = 0x0008; call_16; };
	var rst_10 = function() { var mv = 0x0010; call_16; };
	var rst_18 = function() { var mv = 0x0018; call_16; };
	var rst_20 = function() { var mv = 0x0020; call_16; };
	var rst_28 = function() { var mv = 0x0028; call_16; };
	var rst_30 = function() { var mv = 0x0030; call_16; };
	var rst_38 = function() { var mv = 0x0038; call_16; };

#endregion


	//Final array
	return [
nop,     ld_bcn,  ld_bca,  inc_bc,  inc_b,   dec_b,   ld_bn,   rlca,      ld_psp,  adw_bc,  ld_abc,  dec_bc,  inc_c,   dec_c,  ld_cn,  rrca,
stop,    ld_den,  ld_dea,  inc_de,  inc_d,   dec_d,   ld_dn,   rla,       jr,      adw_de,  ld_ade,  dec_de,  inc_e,   dec_e,  ld_en,  rra,
jr_nz,   ld_hln,  ldi_hla, inc_hl,  inc_h,   dec_h,   ld_hn,   daa,       jr_z,    adw_hl,  ldi_ahl, dec_hl,  inc_l,   dec_l,  ld_ln,  cpl,
jr_nc,   ld_spn,  ldd_hla, inc_sp,  inc_hlp, dec_hlp, ld_hlpn, scf,       jr_c,    adw_sp,  ldd_ahl, dec_sp,  inc_a,   dec_a,  ld_an,  ccf,
																													  			  			  			  		   
ld_bb,   ld_bc,   ld_bd,   ld_be,   ld_bh,   ld_bl,   ld_bhl,  ld_ba,     ld_cb,   ld_cc,   ld_cd,   ld_ce,   ld_ch,   ld_cl,  ld_chl, ld_ca, 
ld_db,   ld_dc,   ld_dd,   ld_de,   ld_dh,   ld_dl,   ld_dhl,  ld_da,     ld_eb,   ld_ec,   ld_ed,   ld_ee,   ld_eh,   ld_el,  ld_ehl, ld_ea, 
ld_hb,   ld_hc,   ld_hd,   ld_he,   ld_hh,   ld_hl,   ld_hhl,  ld_ha,     ld_lb,   ld_lc,   ld_ld,   ld_le,   ld_lh,   ld_ll,  ld_lhl, ld_la, 
ld_hlb,  ld_hlc,  ld_hld,  ld_hle,  ld_hlh,  ld_hll,  halt,    ld_hla,    ld_ab,   ld_ac,   ld_ad,   ld_ae,   ld_ah,   ld_al,  ld_ahl, ld_aa,
				   		   		   		   		   		   		   						  			  			  			  		   
add_b,   add_c,   add_d,   add_e,   add_h,   add_l,   add_hl,  add_a,     adc_b,   adc_c,   adc_d,   adc_e,   adc_h,   adc_l,  adc_hl, adc_a,
sub_b,   sub_c,   sub_d,   sub_e,   sub_h,   sub_l,   sub_hl,  sub_a,     sbc_b,   sbc_c,   sbc_d,   sbc_e,   sbc_h,   sbc_l,  sbc_hl, sbc_a,
and_b,   and_c,   and_d,   and_e,   and_h,   and_l,   and_hl,  and_a,     xor_b,   xor_c,   xor_d,   xor_e,   xor_h,   xor_l,  xor_hl, xor_a,
or_b,    or_c,    or_d,    or_e,    or_h,    or_l,    or_hl,   or_a,      cp_b,    cp_c,    cp_d,    cp_e,    cp_h,    cp_l,   cp_hl,  cp_a,
				   		   		   		   		   		   		   						  			  			  			  		   
ret_nz,  pop_bc,  jp_nz,   jp,      call_nz, push_bc, add_n,   rst_00,    ret_z,   ret,     jp_z,    prefix,  call_z,  call,   adc_n,  rst_08, 
ret_nc,  pop_de,  jp_nc,   inv,     call_nc, push_de, sub_n,   rst_10,    ret_c,   reti,    jp_c,    inv,     call_c,  inv,    sbc_n,  rst_18, 
ldh_na,  pop_hl,  ldh_ca,  inv,     inv,     push_hl, and_n,   rst_20,    add_spe, jp_hl,   ld_pa,   inv,     inv,     inv,    xor_n,  rst_28, 
ldh_an,  pop_af,  ldh_ac,  di,      inv,     push_af, or_n,    rst_30,    ld_hlsp, ld_sphl, ld_ap,   ei,      inv,     inv,    cp_n,   rst_38
	];
}