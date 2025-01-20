extends Node

var i_list : Array = [
	AMULETTE_STRIGIDE, 
	CEINTURE_STRIGIDE, 
	ANNEAU_PADGREF, 
	BOTTES_PADGREF, 
	VOILE_D_ENCRE,
	PATAUGASTRTIQUE,
	BOUCLIER_CYCLOIDE,
	EPEE_DIABLOTINE
	]

const AMULETTE_STRIGIDE : Dictionary = {
	"name" : "Amulette du Strigide",
	"icon_offset" : Vector2(8.5,14),
	"jet" : AMULETTE_STRIGIDE_JET
}

const ANNEAU_PADGREF : Dictionary = {
	"name" : "Anneau de Padgref",
	"icon_offset" : Vector2(269,20),
	"jet" : ANNEAU_PADGREF_JET
}

const CEINTURE_STRIGIDE : Dictionary = {
	"name" : "Ceinture du Strigide",
	"icon_offset" : Vector2(135,20),
	"jet" : CEINTURE_STRIGIDE_JET
}

const BOTTES_PADGREF : Dictionary = {
	"name" : "Getas de Padgref",
	"icon_offset" : Vector2(390,20),
	"jet" : BOTTES_PADGREF_JET
}

const VOILE_D_ENCRE : Dictionary = {
	"name" : "Voile d'encre",
	"icon_offset" : Vector2(500,20),
	"jet" : VOILE_D_ENCRE_JET
}

const PATAUGASTRTIQUE : Dictionary = {
	"name" : "Pataugastrique",
	"icon_offset" : Vector2(625,23),
	"jet" : PATAUGASTRIQUE_JET
}

const BOUCLIER_CYCLOIDE : Dictionary = {
	"name" : "Bouclier du Cycloïde",
	"icon_offset" : Vector2(740,24),
	"jet" : BOUCLIER_CYCLOIDE_JET
}

const EPEE_DIABLOTINE : Dictionary = {
	"name" : "Épée Diablotine",
	"icon_offset" : Vector2(855,20),
	"jet" : EPEE_DIABLOTINE_JET
}

const EPEE_DIABLOTINE_JET : Dictionary = {
	"vi" : [301,350],
	"ine" : [41,60],
	"sa" : [21,30],
	"pui" : [21,30],
	"cri" : [4,5],
	"invo" : [1,1],
	"do_feu" : [11,15],
	"soin" : [11,15],
	"tac" : [7,10],
	"ret_pm" : [4,7],
	"do_cri" : [9,12],
	"re_per_neutre" : [5,7],
	"re_per_feu" : [5,7]
}

const BOUCLIER_CYCLOIDE_JET : Dictionary = {
	"vi" : [201,250],
	"fo" : [51,60],
	"ine" : [51,60],
	"age" : [51,60],
	"sa" : [31,40],
	"cri" : [4,6],
	"tac" : [7,10],
	"re_per_ter" : [5,8],
	"re_per_feu" : [4,6],
	"re_per_air" : [3,4]
}

const PATAUGASTRIQUE_JET : Dictionary = {
	"vi" : [301,350],
	"ine" : [41,60],
	"cha" : [41,60],
	"sa" : [31,40],
	"PA" : [1,1],
	"PM" : [1,1],
	"do_feu" : [9,12],
	"do_eau" : [9,12],
	"tac" : [11,15],
	"ret_pa" : [4,5],
	"do_cri" : [11,15],
	"re_pou" : [-20,-20],
	"re_per_air" : [7,10]
}

const VOILE_D_ENCRE_JET : Dictionary = {
	"vi" : [251,300],
	"fo" : [51,70],
	"ine" : [51,70],
	"sa" : [26,40],
	"cri" : [2,3],
	"PO" : [1,1],
	"do" : [6,10],
	"re_per_feu"  : [6,10],
	"re_per_eau" : [6,10],
	"re_per_air" : [6,10]
}

const BOTTES_PADGREF_JET : Dictionary = {
	"vi" : [101,150],
	"ine" : [41,60],
	"age" : [41,60],
	"cri" : [4,6],
	"PM" : [1,1],
	"do_feu" : [6,8],
	"do_air" : [6,8],
	"tac" : [-8,-6],
	"re_pm" : [-6,-4],
	"do_cri" : [16,20],
	"do_pou" : [11,15],
	"re_per_neutre" : [5,7],
	"re_per_feu" : [5,7]
}

const CEINTURE_STRIGIDE_JET : Dictionary = {
	"vi" : [301,350],
	"sa" : [31,50],
	"pui" : [41,60],
	"cri" : [5,7],
	"do_neutre" : [7,10],
	"do_ter" : [7,10],
	"do_feu" : [7,10],
	"do_eau" : [7,10],
	"do_air" : [7,10],
	"soin" : [5,7],
	"ini" : [301,400],
	"tac" : [7,10],
	"do_cri" : [11,15],
	"re_cri" : [-25,-16],
	"re_per_neutre" : [6,8]
}

const AMULETTE_STRIGIDE_JET : Dictionary = {
	"vi" : [351,400], 
	"pui" : [51,70], 
	"sa" : [31,40], 
	"do_cri" : [16,25], 
	"tac" : [11,15],
	"re_per_ter" : [6,8], 
	"re_per_air" : [6,8], 
	"cri" : [4,6], 
	"re_pa" : [4,6], 
	"PA" : [1,1], 
	"re_cri" : [-20,-16],
	}

const ANNEAU_PADGREF_JET : Dictionary = {
	"vi" : [71,100],
	"ine" : [41,60],
	"age" : [41,60],
	"sa" : [31,41],
	"cri" : [4,6],
	"PO" : [1,1],
	"invo" : [1,1],
	"do_feu" : [5,7],
	"do_air" : [5,7],
	"tac" : [-6,-4],
	"re_pm" : [-4,-3],
	"do_cri" : [8,12],
	"re_per_eau" : [6,8],
	"re_ter" : [7,10],
	"re_air" : [7,10]
}
