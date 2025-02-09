extends Node

var i_list : Array = [
	AMULETTE_STRIGIDE, 
	CEINTURE_STRIGIDE,
	BOTTES_STRIGIDE, 
	ANNEAU_PADGREF, 
	BOTTES_PADGREF,
	COIFFE_PADGREF, 
	VOILE_D_ENCRE,
	PATAUGASTRTIQUE,
	BOUCLIER_CYCLOIDE,
	EPEE_DIABLOTINE,
	CEINTURE_BROUCE,
	FEUILLE_PRINTEMPS,
	DAGOULINANTES,
	COLLIER_BAVDUR,
	CHANT_NECROMANT,
	JACKHIR_ARC
	]

const AMULETTE_STRIGIDE : Dictionary = {
	"name" : "Amulette du Strigide",
	"icon_offset" : Vector2(75,1),
	"jet" : AMULETTE_STRIGIDE_JET
}

const ANNEAU_PADGREF : Dictionary = {
	"name" : "Anneau de Padgref",
	"icon_offset" : Vector2(223,1),
	"jet" : ANNEAU_PADGREF_JET
}

const CEINTURE_STRIGIDE : Dictionary = {
	"name" : "Ceinture du Strigide",
	"icon_offset" : Vector2(149,1),
	"jet" : CEINTURE_STRIGIDE_JET
}

const BOTTES_PADGREF : Dictionary = {
	"name" : "Getas de Padgref",
	"icon_offset" : Vector2(297,1),
	"jet" : BOTTES_PADGREF_JET
}

const VOILE_D_ENCRE : Dictionary = {
	"name" : "Voile d'encre",
	"icon_offset" : Vector2(371,1),
	"jet" : VOILE_D_ENCRE_JET
}

const PATAUGASTRTIQUE : Dictionary = {
	"name" : "Pataugastrique",
	"icon_offset" : Vector2(445,1),
	"jet" : PATAUGASTRIQUE_JET
}

const BOUCLIER_CYCLOIDE : Dictionary = {
	"name" : "Bouclier du Cycloïde",
	"icon_offset" : Vector2(519,1),
	"jet" : BOUCLIER_CYCLOIDE_JET
}

const EPEE_DIABLOTINE : Dictionary = {
	"name" : "Épée Diablotine",
	"icon_offset" : Vector2(593,1),
	"jet" : EPEE_DIABLOTINE_JET
}

const CEINTURE_BROUCE : Dictionary = {
	"name" : "Ceinture de Brouce",
	"icon_offset" : Vector2(668,1),
	"jet" : CEINTURE_BROUCE_JET
}

const FEUILLE_PRINTEMPS : Dictionary = {
	"name" : "La Feuille de Printemps",
	"icon_offset" : Vector2(742,1),
	"jet" : FEUILLE_PRINTEMPS_JET
}

const BOTTES_STRIGIDE : Dictionary = {
	"name" : "Bottes du Strigide",
	"icon_offset" : Vector2(149,76),
	"jet" : BOTTES_STRIGIDE_JET
}

const DAGOULINANTES : Dictionary = {
	"name" : "Dagoulinantes",
	"icon_offset" : Vector2(74,75),
	"jet" : DAGOULINANTES_JET
}

const JACKHIR_ARC : Dictionary = {
	"name" : "Jakchir Arc",
	"icon_offset" : Vector2(1,76),
	"jet" : JAKCHIR_ARC_JET
}

const COLLIER_BAVDUR : Dictionary = {
	"name" : "Collier de Bavdur",
	"icon_offset" : Vector2(890,1),
	"jet" : COLLIER_BAVDUR_JET
}

const COIFFE_PADGREF : Dictionary = {
	"name" : "Coiffe de Padgref",
	"icon_offset" : Vector2(223,75),
	"jet" : COIFFE_PADGREF_JET
}

const CHANT_NECROMANT : Dictionary = {
	"name" : "Chant du Nécromant",
	"icon_offset" : Vector2(815,1),
	"jet" : CHANT_NECROMANT_JET
}

const CHANT_NECROMANT_JET : Dictionary = {
	"vi" : [301,350],
	"fo" : [26,35],
	"ine" : [26,35],
	"cha" : [51,70],
	"age" : [51,70],
	"sa" : [21,30],
	"PA" : [1,1],
	"do_ter" : [4,6],
	"do_feu" : [4,6],
	"do_eau" : [9,12],
	"do_air" : [9,12],
	"re_per_ter" : [6,8],
	"re_per_feu" : [6,8],
	"re_per_eau" : [-4,-4],
	"re_per_air" : [-4,-4],
	"tac" : [3,4],
	"fui" : [-8,-8],
	"re_pa" : [-8,-8],
	"re_pm" : [3,4],
	"re_cri" : [7,10],
	"re_pou" : [-20,-20]
}

const COIFFE_PADGREF_JET : Dictionary = {
	"vi" : [101,150],
	"ine" : [41,60],
	"age" : [41,60],
	"sa" : [31,50],
	"cri" : [5,7],
	"PO" : [1,1],
	"do_feu" : [7,10],
	"do_air" : [7,10],
	"soin" : [6,8],
	"prospe" : [7,10],
	"ini" : [401, 500],
	"re_per_ter" : [6,8],
	"re_per_air" : [6,8],
	"re_eau" : [8,12],
	"tac" : [-10,-7],
	"re_pm" : [-5,-4],
	"do_cri" : [11,15]
}

const COLLIER_BAVDUR_JET : Dictionary = {
	"vi" : [401,500],
	"sa" : [31,40],
	"PA" : [2,2],
	"PO" : [-1,-1],
	"ini" : [701,1000],
	"re_per_neutre" : [2,3],
	"re_per_ter" : [2,3],
	"re_per_feu" : [2,3],
	"re_per_eau" : [2,3],
	"re_per_air" : [2,3],
	"tac" : [16,20],
	"re_pm" : [4,7]
}

const JAKCHIR_ARC_JET : Dictionary = {
	"vi" : [101,150],
	"cha" : [31,50],
	"pui" : [16,20]
}

const DAGOULINANTES_JET : Dictionary = {
	"vi" : [301,400],
	"cha" : [61,80],
	"sa" : [31,50],
	"cri" : [4,6],
	"PO" : [1,1],
	"do_eau" : [16,20],
	"re_per_neutre" : [5,7],
	"re_per_feu" : [5,7],
	"ret_pa" : [7,10]
}

const BOTTES_STRIGIDE_JET : Dictionary = {
	"vi" : [351,400],
	"sa" : [31,50],
	"pui" : [51,75],
	"PM" : [1,1],
	"do_neutre" : [9,13],
	"do_ter" : [9,13],
	"do_feu" : [9,13],
	"do_eau" : [9,13],
	"do_air" : [9,13],
	"re_per_feu" : [6,8],
	"re_pa" : [6,8],
	"re_cri" : [-20,-16]
}

const FEUILLE_PRINTEMPS_JET : Dictionary = {
	"vi" : [41,70],
	"cha" : [31,50],
	"age" : [31,50],
	"PA" : [1,1],
	"PO" : [1,2],
	"do" : [6,10],
	"prospe" : [11,15],
	"re_per_feu" : [3,5],
	"re_per_eau" : [3,5]
}

const CEINTURE_BROUCE_JET : Dictionary = {
	"vi" : [351,400],
	"fo" : [71,100],
	"sa" : [21,30],
	"cri" : [4,6],
	"PO" : [1,2],
	"do_neutre" : [14,18],
	"do_ter" : [14,18],
	"re_neutre" : [11,15],
	"re_pm" : [5,7],
	"re_cri" : [11,15]
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
