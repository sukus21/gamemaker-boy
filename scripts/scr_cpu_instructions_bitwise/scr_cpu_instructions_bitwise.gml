/*function instructions_bitwise()
{
	//Macro I need :,(
	#macro bwl optable[bytes[0]].cycles = optable_bitwise[bytes[1]].cycles
	
	//Rotate register left
	var rlc_a = new opc(function(){ return "rlc a"; }, function(){ bwl; a = rot_cl(a); }, 2, 8);
	var rlcb = new opc(function(){ return "rlc b"; }, function(){ bwl; b = rot_cl(b); }, 2, 8);
	var rlcc = new opc(function(){ return "rlc c"; }, function(){ bwl; c = rot_cl(c); }, 2, 8);
	var rlcd = new opc(function(){ return "rlc d"; }, function(){ bwl; d = rot_cl(d); }, 2, 8);
	var rlce = new opc(function(){ return "rlc e"; }, function(){ bwl; e = rot_cl(e); }, 2, 8);
	var rlch = new opc(function(){ return "rlc h"; }, function(){ bwl; h = rot_cl(h); }, 2, 8);
	var rlcl = new opc(function(){ return "rlc l"; }, function(){ bwl; l = rot_cl(l); }, 2, 8);
	var rlchl = new opc(function(){ return "rlc [hl]"; }, function(){ bwl; mmap_write(hl, rot_cl(mmap_read(hl))); }, 2, 16);
	
	var rl_a = new opc(function(){ return "rl a"; }, function(){ bwl; a = rot_l(a); }, 2, 8);
	var rlb = new opc(function(){ return "rl b"; }, function(){ bwl; b = rot_l(b); }, 2, 8);
	var rlc = new opc(function(){ return "rl c"; }, function(){ bwl; c = rot_l(c); }, 2, 8);
	var rld = new opc(function(){ return "rl d"; }, function(){ bwl; d = rot_l(d); }, 2, 8);
	var rle = new opc(function(){ return "rl e"; }, function(){ bwl; e = rot_l(e); }, 2, 8);
	var rlh = new opc(function(){ return "rl h"; }, function(){ bwl; h = rot_l(h); }, 2, 8);
	var rll = new opc(function(){ return "rl l"; }, function(){ bwl; l = rot_l(l); }, 2, 8);
	var rlhl = new opc(function(){ return "rl [hl]"; }, function(){ bwl; mmap_write(hl, rot_l(mmap_read(hl))); }, 2, 16);
	
	//Rotate register right
	var rrc_a = new opc(function(){ return "rrc a"; }, function(){ bwl; a = rot_cr(a); }, 2, 8);
	var rrcb = new opc(function(){ return "rrc b"; }, function(){ bwl; b = rot_cr(b); }, 2, 8);
	var rrcc = new opc(function(){ return "rrc c"; }, function(){ bwl; c = rot_cr(c); }, 2, 8);
	var rrcd = new opc(function(){ return "rrc d"; }, function(){ bwl; d = rot_cr(d); }, 2, 8);
	var rrce = new opc(function(){ return "rrc e"; }, function(){ bwl; e = rot_cr(e); }, 2, 8);
	var rrch = new opc(function(){ return "rrc h"; }, function(){ bwl; h = rot_cr(h); }, 2, 8);
	var rrcl = new opc(function(){ return "rrc l"; }, function(){ bwl; l = rot_cr(l); }, 2, 8);
	var rrchl = new opc(function(){ return "rrc [hl]"; }, function(){ bwl; mmap_write(hl, rot_cr(mmap_read(hl))); }, 2, 16);
	
	var rr_a = new opc(function(){ return "rr a"; }, function(){ bwl; a = rot_r(a); }, 2, 8);
	var rrb = new opc(function(){ return "rr b"; }, function(){ bwl; b = rot_r(b); }, 2, 8);
	var rrc = new opc(function(){ return "rr c"; }, function(){ bwl; c = rot_r(c); }, 2, 8);
	var rrd = new opc(function(){ return "rr d"; }, function(){ bwl; d = rot_r(d); }, 2, 8);
	var rre = new opc(function(){ return "rr e"; }, function(){ bwl; e = rot_r(e); }, 2, 8);
	var rrh = new opc(function(){ return "rr h"; }, function(){ bwl; h = rot_r(h); }, 2, 8);
	var rrl = new opc(function(){ return "rr l"; }, function(){ bwl; l = rot_r(l); }, 2, 8);
	var rrhl = new opc(function(){ return "rr [hl]"; }, function(){ bwl; mmap_write(hl, rot_r(mmap_read(hl))); }, 2, 16);
	
	//Shifts
	//Arithmetic
	var slaa = new opc(function(){ return "sla a"; }, function(){ bwl; a = sla(a); }, 2, 8);
	var slab = new opc(function(){ return "sla b"; }, function(){ bwl; b = sla(b); }, 2, 8);
	var slac = new opc(function(){ return "sla c"; }, function(){ bwl; c = sla(c); }, 2, 8);
	var slad = new opc(function(){ return "sla d"; }, function(){ bwl; d = sla(d); }, 2, 8);
	var slae = new opc(function(){ return "sla e"; }, function(){ bwl; e = sla(e); }, 2, 8);
	var slah = new opc(function(){ return "sla h"; }, function(){ bwl; h = sla(h); }, 2, 8);
	var slal = new opc(function(){ return "sla l"; }, function(){ bwl; l = sla(l); }, 2, 8);
	var slahl = new opc(function(){ return "sla [hl]"; }, function(){ bwl; mmap_write(hl, sla(mmap_read(hl))); }, 2, 16);
	
	var sraa = new opc(function(){ return "sra a"; }, function(){ bwl; a = sra(a); }, 2, 8);
	var srab = new opc(function(){ return "sra b"; }, function(){ bwl; b = sra(b); }, 2, 8);
	var srac = new opc(function(){ return "sra c"; }, function(){ bwl; c = sra(c); }, 2, 8);
	var srad = new opc(function(){ return "sra d"; }, function(){ bwl; d = sra(d); }, 2, 8);
	var srae = new opc(function(){ return "sra e"; }, function(){ bwl; e = sra(e); }, 2, 8);
	var srah = new opc(function(){ return "sra h"; }, function(){ bwl; h = sra(h); }, 2, 8);
	var sral = new opc(function(){ return "sra l"; }, function(){ bwl; l = sra(l); }, 2, 8);
	var srahl = new opc(function(){ return "sra [hl]"; }, function(){ bwl; mmap_write(hl, sra(mmap_read(hl))); }, 2, 16);
	
	//Logical
	var srla = new opc(function(){ return "srl a"; }, function(){ bwl; a = srl(a); }, 2, 8);
	var srlb = new opc(function(){ return "srl b"; }, function(){ bwl; b = srl(b); }, 2, 8);
	var srlc = new opc(function(){ return "srl c"; }, function(){ bwl; c = srl(c); }, 2, 8);
	var srld = new opc(function(){ return "srl d"; }, function(){ bwl; d = srl(d); }, 2, 8);
	var srle = new opc(function(){ return "srl e"; }, function(){ bwl; e = srl(e); }, 2, 8);
	var srlh = new opc(function(){ return "srl h"; }, function(){ bwl; h = srl(h); }, 2, 8);
	var srll = new opc(function(){ return "srl l"; }, function(){ bwl; l = srl(l); }, 2, 8);
	var srlhl = new opc(function(){ return "srl [hl]"; }, function(){ bwl; mmap_write(hl, srl(mmap_read(hl))); }, 2, 16);
	
	//Swap
	var swapa = new opc(function(){ return "swap a"; }, function(){ bwl; a = swap(a); }, 2, 8);
	var swapb = new opc(function(){ return "swap b"; }, function(){ bwl; b = swap(b); }, 2, 8);
	var swapc = new opc(function(){ return "swap c"; }, function(){ bwl; c = swap(c); }, 2, 8);
	var swapd = new opc(function(){ return "swap d"; }, function(){ bwl; d = swap(d); }, 2, 8);
	var swape = new opc(function(){ return "swap e"; }, function(){ bwl; e = swap(e); }, 2, 8);
	var swaph = new opc(function(){ return "swap h"; }, function(){ bwl; h = swap(h); }, 2, 8);
	var swapl = new opc(function(){ return "swap l"; }, function(){ bwl; l = swap(l); }, 2, 8);
	var swaphl = new opc(function(){ return "swap [hl]"; }, function(){ bwl; mmap_write(hl, swap(mmap_read(hl))); }, 2, 16);
	
	
	
	//bit functions
	//a
	var bita0 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 0); }, 2, 8);
	var bita1 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 1); }, 2, 8);
	var bita2 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 2); }, 2, 8);
	var bita3 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 3); }, 2, 8);
	var bita4 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 4); }, 2, 8);
	var bita5 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 5); }, 2, 8);
	var bita6 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 6); }, 2, 8);
	var bita7 = new opc(function(){ return "bit u3, a"; }, function(){ bwl; bit(a, 7); }, 2, 8);
	
	//b
	var bitb0 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 0); }, 2, 8);
	var bitb1 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 1); }, 2, 8);
	var bitb2 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 2); }, 2, 8);
	var bitb3 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 3); }, 2, 8);
	var bitb4 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 4); }, 2, 8);
	var bitb5 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 5); }, 2, 8);
	var bitb6 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 6); }, 2, 8);
	var bitb7 = new opc(function(){ return "bit u3, b"; }, function(){ bwl; bit(b, 7); }, 2, 8);
	
	//c
	var bitc0 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 0); }, 2, 8);
	var bitc1 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 1); }, 2, 8);
	var bitc2 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 2); }, 2, 8);
	var bitc3 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 3); }, 2, 8);
	var bitc4 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 4); }, 2, 8);
	var bitc5 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 5); }, 2, 8);
	var bitc6 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 6); }, 2, 8);
	var bitc7 = new opc(function(){ return "bit u3, c"; }, function(){ bwl; bit(c, 7); }, 2, 8);
	
	//d
	var bitd0 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 0); }, 2, 8);
	var bitd1 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 1); }, 2, 8);
	var bitd2 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 2); }, 2, 8);
	var bitd3 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 3); }, 2, 8);
	var bitd4 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 4); }, 2, 8);
	var bitd5 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 5); }, 2, 8);
	var bitd6 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 6); }, 2, 8);
	var bitd7 = new opc(function(){ return "bit u3, d"; }, function(){ bwl; bit(d, 7); }, 2, 8);
	
	//e
	var bite0 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 0); }, 2, 8);
	var bite1 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 1); }, 2, 8);
	var bite2 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 2); }, 2, 8);
	var bite3 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 3); }, 2, 8);
	var bite4 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 4); }, 2, 8);
	var bite5 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 5); }, 2, 8);
	var bite6 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 6); }, 2, 8);
	var bite7 = new opc(function(){ return "bit u3, e"; }, function(){ bwl; bit(e, 7); }, 2, 8);
	
	//h
	var bith0 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 0); }, 2, 8);
	var bith1 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 1); }, 2, 8);
	var bith2 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 2); }, 2, 8);
	var bith3 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 3); }, 2, 8);
	var bith4 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 4); }, 2, 8);
	var bith5 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 5); }, 2, 8);
	var bith6 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 6); }, 2, 8);
	var bith7 = new opc(function(){ return "bit u3, h"; }, function(){ bwl; bit(h, 7); }, 2, 8);
	
	//l
	var bitl0 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 0); }, 2, 8);
	var bitl1 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 1); }, 2, 8);
	var bitl2 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 2); }, 2, 8);
	var bitl3 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 3); }, 2, 8);
	var bitl4 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 4); }, 2, 8);
	var bitl5 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 5); }, 2, 8);
	var bitl6 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 6); }, 2, 8);
	var bitl7 = new opc(function(){ return "bit u3, l"; }, function(){ bwl; bit(l, 7); }, 2, 8);
	
	//[hl]
	var bithl0 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 0); }, 2, 16);
	var bithl1 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 1); }, 2, 16);
	var bithl2 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 2); }, 2, 16);
	var bithl3 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 3); }, 2, 16);
	var bithl4 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 4); }, 2, 16);
	var bithl5 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 5); }, 2, 16);
	var bithl6 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 6); }, 2, 16);
	var bithl7 = new opc(function(){ return "bit u3, [hl]"; }, function(){ bwl; bit(mmap_read(hl), 7); }, 2, 16);
	
	
	
	
	
	//res functions
	//a
	var resa0 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 0); }, 2, 8);
	var resa1 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 1); }, 2, 8);
	var resa2 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 2); }, 2, 8);
	var resa3 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 3); }, 2, 8);
	var resa4 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 4); }, 2, 8);
	var resa5 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 5); }, 2, 8);
	var resa6 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 6); }, 2, 8);
	var resa7 = new opc(function(){ return "res u3, a"; }, function(){ bwl; a = res(a, 7); }, 2, 8);
	
	//b
	var resb0 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 0); }, 2, 8);
	var resb1 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 1); }, 2, 8);
	var resb2 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 2); }, 2, 8);
	var resb3 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 3); }, 2, 8);
	var resb4 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 4); }, 2, 8);
	var resb5 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 5); }, 2, 8);
	var resb6 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 6); }, 2, 8);
	var resb7 = new opc(function(){ return "res u3, b"; }, function(){ bwl; b = res(b, 7); }, 2, 8);
	
	//c
	var resc0 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 0); }, 2, 8);
	var resc1 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 1); }, 2, 8);
	var resc2 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 2); }, 2, 8);
	var resc3 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 3); }, 2, 8);
	var resc4 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 4); }, 2, 8);
	var resc5 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 5); }, 2, 8);
	var resc6 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 6); }, 2, 8);
	var resc7 = new opc(function(){ return "res u3, c"; }, function(){ bwl; c = res(c, 7); }, 2, 8);
	
	//d
	var resd0 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 0); }, 2, 8);
	var resd1 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 1); }, 2, 8);
	var resd2 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 2); }, 2, 8);
	var resd3 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 3); }, 2, 8);
	var resd4 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 4); }, 2, 8);
	var resd5 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 5); }, 2, 8);
	var resd6 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 6); }, 2, 8);
	var resd7 = new opc(function(){ return "res u3, d"; }, function(){ bwl; d = res(d, 7); }, 2, 8);
	
	//e
	var rese0 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 0); }, 2, 8);
	var rese1 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 1); }, 2, 8);
	var rese2 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 2); }, 2, 8);
	var rese3 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 3); }, 2, 8);
	var rese4 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 4); }, 2, 8);
	var rese5 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 5); }, 2, 8);
	var rese6 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 6); }, 2, 8);
	var rese7 = new opc(function(){ return "res u3, e"; }, function(){ bwl; e = res(e, 7); }, 2, 8);
	
	//h
	var resh0 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 0); }, 2, 8);
	var resh1 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 1); }, 2, 8);
	var resh2 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 2); }, 2, 8);
	var resh3 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 3); }, 2, 8);
	var resh4 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 4); }, 2, 8);
	var resh5 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 5); }, 2, 8);
	var resh6 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 6); }, 2, 8);
	var resh7 = new opc(function(){ return "res u3, h"; }, function(){ bwl; h = res(h, 7); }, 2, 8);
	
	//l
	var resl0 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 0); }, 2, 8);
	var resl1 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 1); }, 2, 8);
	var resl2 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 2); }, 2, 8);
	var resl3 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 3); }, 2, 8);
	var resl4 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 4); }, 2, 8);
	var resl5 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 5); }, 2, 8);
	var resl6 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 6); }, 2, 8);
	var resl7 = new opc(function(){ return "res u3, l"; }, function(){ bwl; l = res(l, 7); }, 2, 8);
	
	//[hl]
	var reshl0 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 0)); }, 2, 16);
	var reshl1 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 1)); }, 2, 16);
	var reshl2 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 2)); }, 2, 16);
	var reshl3 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 3)); }, 2, 16);
	var reshl4 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 4)); }, 2, 16);
	var reshl5 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 5)); }, 2, 16);
	var reshl6 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 6)); }, 2, 16);
	var reshl7 = new opc(function(){ return "res u3, [hl]"; }, function(){ bwl; mmap_write(hl, res(mmap_read(hl), 7)); }, 2, 16);
	
	
	
	
	
	//res functions
	//a
	var seta0 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 0); }, 2, 8);
	var seta1 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 1); }, 2, 8);
	var seta2 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 2); }, 2, 8);
	var seta3 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 3); }, 2, 8);
	var seta4 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 4); }, 2, 8);
	var seta5 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 5); }, 2, 8);
	var seta6 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 6); }, 2, 8);
	var seta7 = new opc(function(){ return "set u3, a"; }, function(){ bwl; a = set(a, 7); }, 2, 8);
	
	//b
	var setb0 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 0); }, 2, 8);
	var setb1 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 1); }, 2, 8);
	var setb2 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 2); }, 2, 8);
	var setb3 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 3); }, 2, 8);
	var setb4 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 4); }, 2, 8);
	var setb5 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 5); }, 2, 8);
	var setb6 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 6); }, 2, 8);
	var setb7 = new opc(function(){ return "set u3, b"; }, function(){ bwl; b = set(b, 7); }, 2, 8);
	
	//c
	var setc0 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 0); }, 2, 8);
	var setc1 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 1); }, 2, 8);
	var setc2 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 2); }, 2, 8);
	var setc3 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 3); }, 2, 8);
	var setc4 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 4); }, 2, 8);
	var setc5 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 5); }, 2, 8);
	var setc6 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 6); }, 2, 8);
	var setc7 = new opc(function(){ return "set u3, c"; }, function(){ bwl; c = set(c, 7); }, 2, 8);
	
	//d
	var setd0 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 0); }, 2, 8);
	var setd1 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 1); }, 2, 8);
	var setd2 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 2); }, 2, 8);
	var setd3 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 3); }, 2, 8);
	var setd4 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 4); }, 2, 8);
	var setd5 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 5); }, 2, 8);
	var setd6 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 6); }, 2, 8);
	var setd7 = new opc(function(){ return "set u3, d"; }, function(){ bwl; d = set(d, 7); }, 2, 8);
	
	//e
	var sete0 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 0); }, 2, 8);
	var sete1 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 1); }, 2, 8);
	var sete2 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 2); }, 2, 8);
	var sete3 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 3); }, 2, 8);
	var sete4 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 4); }, 2, 8);
	var sete5 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 5); }, 2, 8);
	var sete6 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 6); }, 2, 8);
	var sete7 = new opc(function(){ return "set u3, e"; }, function(){ bwl; e = set(e, 7); }, 2, 8);
	
	//h
	var seth0 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 0); }, 2, 8);
	var seth1 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 1); }, 2, 8);
	var seth2 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 2); }, 2, 8);
	var seth3 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 3); }, 2, 8);
	var seth4 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 4); }, 2, 8);
	var seth5 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 5); }, 2, 8);
	var seth6 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 6); }, 2, 8);
	var seth7 = new opc(function(){ return "set u3, h"; }, function(){ bwl; h = set(h, 7); }, 2, 8);
	
	//l
	var setl0 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 0); }, 2, 8);
	var setl1 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 1); }, 2, 8);
	var setl2 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 2); }, 2, 8);
	var setl3 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 3); }, 2, 8);
	var setl4 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 4); }, 2, 8);
	var setl5 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 5); }, 2, 8);
	var setl6 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 6); }, 2, 8);
	var setl7 = new opc(function(){ return "set u3, l"; }, function(){ bwl; l = set(l, 7); }, 2, 8);
	
	//[hl]
	var sethl0 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 0)); }, 2, 16);
	var sethl1 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 1)); }, 2, 16);
	var sethl2 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 2)); }, 2, 16);
	var sethl3 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 3)); }, 2, 16);
	var sethl4 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 4)); }, 2, 16);
	var sethl5 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 5)); }, 2, 16);
	var sethl6 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 6)); }, 2, 16);
	var sethl7 = new opc(function(){ return "set u3, [hl]"; }, function(){ bwl; mmap_write(hl, set(mmap_read(hl), 7)); }, 2, 16);
	
	//Optable
	optable_bitwise = 
	[ 
	rlcb,   rlcc,    rlcd,  rlce,    rlch,    rlcl,   rlchl,    rlc_a, rrcb,  rrcc,  rrcd, rrce,  rrch,  rrcl, rrchl,  rrc_a,
	rlb ,   rlc,     rld,    rle,     rlh,     rll,    rlhl,     rl_a,   rrb,   rrc,   rrd,  rre,   rrh,   rrl,   rrhl,   rr_a,
	slab,   slac,   slad,   slae,    slah,   slal,   slahl,   slaa,    srab,  srac, srad, srae,  srah, sral,  srahl,  sraa,
	swapb, swapc, swapd, swape, swaph, swapl, swaphl, swapa,  srlb,  srlc,  srld,  srle,  srlh,  srll,   srlhl,  srla,
	
	bitb0, bitc0, bitd0, bite0, bith0, bitl0, bithl0, bita0, bitb1, bitc1, bitd1, bite1, bith1, bitl1, bithl1, bita1, 
	bitb2, bitc2, bitd2, bite2, bith2, bitl2, bithl2, bita2, bitb3, bitc3, bitd3, bite3, bith3, bitl3, bithl3, bita3, 
	bitb4, bitc4, bitd4, bite4, bith4, bitl4, bithl4, bita4, bitb5, bitc5, bitd5, bite5, bith5, bitl5, bithl5, bita5, 
	bitb6, bitc6, bitd6, bite6, bith6, bitl6, bithl6, bita6, bitb7, bitc7, bitd7, bite7, bith7, bitl7, bithl7, bita7, 
	
	resb0, resc0, resd0, rese0, resh0, resl0, reshl0, resa0, resb1, resc1, resd1, rese1, resh1, resl1, reshl1, resa1, 
	resb2, resc2, resd2, rese2, resh2, resl2, reshl2, resa2, resb3, resc3, resd3, rese3, resh3, resl3, reshl3, resa3, 
	resb4, resc4, resd4, rese4, resh4, resl4, reshl4, resa4, resb5, resc5, resd5, rese5, resh5, resl5, reshl5, resa5, 
	resb6, resc6, resd6, rese6, resh6, resl6, reshl6, resa6, resb7, resc7, resd7, rese7, resh7, resl7, reshl7, resa7, 
	
	setb0, setc0, setd0, sete0, seth0, setl0, sethl0, seta0, setb1, setc1, setd1, sete1, seth1, setl1, sethl1, seta1, 
	setb2, setc2, setd2, sete2, seth2, setl2, sethl2, seta2, setb3, setc3, setd3, sete3, seth3, setl3, sethl3, seta3, 
	setb4, setc4, setd4, sete4, seth4, setl4, sethl4, seta4, setb5, setc5, setd5, sete5, seth5, setl5, sethl5, seta5, 
	setb6, setc6, setd6, sete6, seth6, setl6, sethl6, seta6, setb7, setc7, setd7, sete7, seth7, setl7, sethl7, seta7
	];
}