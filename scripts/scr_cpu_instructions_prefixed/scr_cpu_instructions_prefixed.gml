function scr_cpu_instructions_prefixed() {
	
	//Rotate left
	#macro rlc_8 fC = mv & 0x80 != 0; mv = (mv << 1) & 0xFF; mv |= fC; fZ = mv == 0; fH = 0; fN = 0
	var rlca = function() { var mv = a; rlc_8; a = mv; };
	var rlcb = function() { var mv = b; rlc_8; b = mv; };
	var rlcc = function() { var mv = c; rlc_8; c = mv; };
	var rlcd = function() { var mv = d; rlc_8; d = mv; };
	var rlce = function() { var mv = e; rlc_8; e = mv; };
	var rlch = function() { var mv = h; rlc_8; h = mv; };
	var rlcl = function() { var mv = l; rlc_8; l = mv; };
	var rlchl= function() { var mv = hl_read; rlc_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	#macro rl_8 var _p = mv & 0x80 != 0; mv = (mv << 1) & 0xFF; mv |= fC; fC = _p; fZ = mv == 0; fH = 0; fN = 0
	var rla = function() { var mv = a; rl_8; a = mv; };
	var rlb = function() { var mv = b; rl_8; b = mv; };
	var rlc = function() { var mv = c; rl_8; c = mv; };
	var rld = function() { var mv = d; rl_8; d = mv; };
	var rle = function() { var mv = e; rl_8; e = mv; };
	var rlh = function() { var mv = h; rl_8; h = mv; };
	var rll = function() { var mv = l; rl_8; l = mv; };
	var rlhl= function() { var mv = hl_read; rl_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Rotate right
	#macro rrc_8 fC = mv & 0x01; mv = (mv >> 1) & 0xFF; mv |= fC << 7; fZ = mv == 0; fH = 0; fN = 0
	var rrca = function() { var mv = a; rrc_8; a = mv; };
	var rrcb = function() { var mv = b; rrc_8; b = mv; };
	var rrcc = function() { var mv = c; rrc_8; c = mv; };
	var rrcd = function() { var mv = d; rrc_8; d = mv; };
	var rrce = function() { var mv = e; rrc_8; e = mv; };
	var rrch = function() { var mv = h; rrc_8; h = mv; };
	var rrcl = function() { var mv = l; rrc_8; l = mv; };
	var rrchl= function() { var mv = hl_read; rrc_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	#macro rr_8 var _p = mv & 0x01; mv = (mv >> 1) & 0xFF; mv |= fC << 7; fC = _p; fZ = mv == 0; fH = 0; fN = 0
	var rra = function() { var mv = a; rr_8; a = mv; };
	var rrb = function() { var mv = b; rr_8; b = mv; };
	var rrc = function() { var mv = c; rr_8; c = mv; };
	var rrd = function() { var mv = d; rr_8; d = mv; };
	var rre = function() { var mv = e; rr_8; e = mv; };
	var rrh = function() { var mv = h; rr_8; h = mv; };
	var rrl = function() { var mv = l; rr_8; l = mv; };
	var rrhl= function() { var mv = hl_read; rr_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Shift left Arithmetic
	#macro sla_8 fC = mv & 0x80 != 0; mv = (mv << 1) & 0xFE; fZ = mv == 0; fH = 0; fN = 0
	var slaa = function() { var mv = a; sla_8; a = mv; };
	var slab = function() { var mv = b; sla_8; b = mv; };
	var slac = function() { var mv = c; sla_8; c = mv; };
	var slad = function() { var mv = d; sla_8; d = mv; };
	var slae = function() { var mv = e; sla_8; e = mv; };
	var slah = function() { var mv = h; sla_8; h = mv; };
	var slal = function() { var mv = l; sla_8; l = mv; };
	var slahl= function() { var mv = hl_read; sla_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Shift right Arithmetic
	#macro sra_8 fC = mv & 0x01; var _p = mv & 0x80; mv = (mv >> 1) & 0x7F; mv |= _p; fZ = mv == 0; fH = 0; fN = 0
	var sraa = function() { var mv = a; sra_8; a = mv; };
	var srab = function() { var mv = b; sra_8; b = mv; };
	var srac = function() { var mv = c; sra_8; c = mv; };
	var srad = function() { var mv = d; sra_8; d = mv; };
	var srae = function() { var mv = e; sra_8; e = mv; };
	var srah = function() { var mv = h; sra_8; h = mv; };
	var sral = function() { var mv = l; sra_8; l = mv; };
	var srahl= function() { var mv = hl_read; sra_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Shift right logical
	#macro srl_8 fC = mv & 0x01; mv = (mv >> 1) & 0x7F; fZ = mv == 0; fH = 0; fN = 0
	var srla = function() { var mv = a; srl_8; a = mv; };
	var srlb = function() { var mv = b; srl_8; b = mv; };
	var srlc = function() { var mv = c; srl_8; c = mv; };
	var srld = function() { var mv = d; srl_8; d = mv; };
	var srle = function() { var mv = e; srl_8; e = mv; };
	var srlh = function() { var mv = h; srl_8; h = mv; };
	var srll = function() { var mv = l; srl_8; l = mv; };
	var srlhl= function() { var mv = hl_read; srl_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Nybble swap
	#macro swap_8 var _p = (mv << 4) & 0xF0; mv = (mv >> 4) & 0x0F; mv |= _p; fZ = mv == 0; fC = 0; fH = 0; fN = 0
	var swapa = function() { var mv = a; swap_8; a = mv; };
	var swapb = function() { var mv = b; swap_8; b = mv; };
	var swapc = function() { var mv = c; swap_8; c = mv; };
	var swapd = function() { var mv = d; swap_8; d = mv; };
	var swape = function() { var mv = e; swap_8; e = mv; };
	var swaph = function() { var mv = h; swap_8; h = mv; };
	var swapl = function() { var mv = l; swap_8; l = mv; };
	var swaphl= function() { var mv = hl_read; swap_8; var hlw = mv; hl_write; cycles_c += 8; };
	
	//Bit functions
	#macro bit_8 fZ = !((re >> mv) & 1); fH = 1; fN = 0
	#macro bit_gb ((subcode >> 3) & 0x07)
	var bita =  function(subcode) { var re = a; var mv = bit_gb; bit_8; };
	var bitb =  function(subcode) { var re = b; var mv = bit_gb; bit_8; };
	var bitc =  function(subcode) { var re = c; var mv = bit_gb; bit_8; };
	var bitd =  function(subcode) { var re = d; var mv = bit_gb; bit_8; };
	var bite =  function(subcode) { var re = e; var mv = bit_gb; bit_8; };
	var bith =  function(subcode) { var re = h; var mv = bit_gb; bit_8; };
	var bitl =  function(subcode) { var re = l; var mv = bit_gb; bit_8; };
	var bithl = function(subcode) { var re = hl_read; var mv = bit_gb; bit_8; cycles_c += 8; };
	
	//Set functions
	#macro set_8 re |= 1 << mv
	var seta =  function(subcode) { var re = a; var mv = bit_gb; set_8; a = re; };
	var setb =  function(subcode) { var re = b; var mv = bit_gb; set_8; b = re; };
	var setc =  function(subcode) { var re = c; var mv = bit_gb; set_8; c = re; };
	var setd =  function(subcode) { var re = d; var mv = bit_gb; set_8; d = re; };
	var sete =  function(subcode) { var re = e; var mv = bit_gb; set_8; e = re; };
	var seth =  function(subcode) { var re = h; var mv = bit_gb; set_8; h = re; };
	var setl =  function(subcode) { var re = l; var mv = bit_gb; set_8; l = re; };
	var sethl = function(subcode) { var re = hl_read; var mv = bit_gb; set_8; var hlw = re; hl_write; cycles_c += 8; };
	
	//Res functions
	#macro res_8 re &= (1 << mv) ^ 0xFF
	var resa =  function(subcode) { var re = a; var mv = bit_gb; res_8; a = re; };
	var resb =  function(subcode) { var re = b; var mv = bit_gb; res_8; b = re; };
	var resc =  function(subcode) { var re = c; var mv = bit_gb; res_8; c = re; };
	var resd =  function(subcode) { var re = d; var mv = bit_gb; res_8; d = re; };
	var rese =  function(subcode) { var re = e; var mv = bit_gb; res_8; e = re; };
	var resh =  function(subcode) { var re = h; var mv = bit_gb; res_8; h = re; };
	var resl =  function(subcode) { var re = l; var mv = bit_gb; res_8; l = re; };
	var reshl = function(subcode) { var re = hl_read; var mv = bit_gb; res_8; var hlw = re; hl_write; cycles_c += 8; };
	
	
	//Return optable
	return [ 
rlcb,  rlcc,  rlcd,  rlce,  rlch,  rlcl,  rlchl,  rlca,       rrcb,  rrcc,  rrcd,  rrce,  rrch,  rrcl,  rrchl,  rrca,
rlb ,  rlc,   rld,   rle,   rlh,   rll,   rlhl,   rla,        rrb,   rrc,   rrd,   rre,   rrh,   rrl,   rrhl,   rra,
slab,  slac,  slad,  slae,  slah,  slal,  slahl,  slaa,       srab,  srac,  srad,  srae,  srah,  sral,  srahl,  sraa,
swapb, swapc, swapd, swape, swaph, swapl, swaphl, swapa,      srlb,  srlc,  srld,  srle,  srlh,  srll,  srlhl,  srla,
		 		 		  		  		 	   	   
bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita,       bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita, 
bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita,       bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita, 
bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita,       bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita, 
bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita,       bitb,  bitc,  bitd,  bite,  bith,  bitl,  bithl,  bita, 
		 		   	     		 		   	   		  				  		   		 		  		   		 		 		   
resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa,       resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa, 
resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa,       resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa, 
resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa,       resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa, 
resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa,       resb,  resc,  resd,  rese,  resh,  resl,  reshl,  resa, 
		 		   	     		 		   	   		  				  		   		 		  		   		 		 		   
setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta,       setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta, 
setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta,       setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta, 
setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta,       setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta, 
setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta,       setb,  setc,  setd,  sete,  seth,  setl,  sethl,  seta
	];
}