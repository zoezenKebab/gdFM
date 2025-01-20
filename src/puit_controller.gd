extends Node

@onready var i_controller = get_parent().get_node("ItemController")

var reliquat : float = 0


func max_weight_check(stat_line : String, amount : int) -> bool:
	
	#the weight of the line would the rune pass
	var wanted_weight = i_controller.loaded_item_stats.get(stat_line) + amount
	var check_passed = true
	#checks if the wanted weight > the max weight posssible of the rune
	if wanted_weight > globals.STATS_TABLE.get(stat_line)[4]:
		check_passed = false
		
		#if the max of the item exceeds the max of the rune, ovverides it
		if wanted_weight <= i_controller.loaded_item_jet_theorique.get(stat_line)[1]:
			check_passed = true
	
	return check_passed


# % chances of outcome "sc" = succes_crit, "sn" = succes_neutre, "ec" = echec_crit
var outcome_thresholds : Dictionary = {"sc" : 10, "sn" : 80, "ec" : 100}

func calculate_outcome(stat_name : String, rune_type : Array)-> String:
	#the runes that will be removed/added
	var fm_results : Dictionary
	#the key pointing to the dict of thresholds
	var outcome_key : String
	
	#updates the thresholds based on item_stats and wanted_rune
	update_outcome_thresholds(stat_name, rune_type)
	
	var outcome_r : int = randi_range(0,100)
	#loops through the thresholds from small to big
	#if found rand_i < threshold, break and return threshold
	for threshold in outcome_thresholds:
		if outcome_r <= outcome_thresholds.get(threshold):
			outcome_key = threshold
			break
	
	return outcome_key

#max = 160
#the more points the more chances of sc
var stat_differential_pts = 40
var rune_weight_pts = 60
var line_weight_pts = 80
var item_weight_pts = 40
var is_exo_pts = 10


func update_outcome_thresholds(stat_name : String, rune_type : Array)-> void:
	
	#WARNING : if is exo = crash
	var current_stat : float = i_controller.loaded_item_stats[stat_name]
	var rune_stat : float = globals.STATS_TABLE[stat_name][rune_type[1]]
	var differential_ratio : float = current_stat / rune_stat
	var differential_directional_coeff : float = -0.02 if differential_ratio > 10.0 else -0.05
	var stat_differential : float = differential_directional_coeff * (differential_ratio) + 1
	#print("stat_differential = ", stat_differential)
	
	var e : float = 2.71828
	
	var line_weight_ratio : float = i_controller.get_line_weight(stat_name, false) / i_controller.get_line_weight(stat_name, true)
	var line_weight : float = e ** -(line_weight_ratio ** 2) / 0.98
	#print("line_weight = ", line_weight)
	
	var total_weight_ratio : float = i_controller.get_total_weight(false) / i_controller.get_total_weight(true)
	var item_weight : float = e ** -(total_weight_ratio ** 2) / 1.28
	#print("item_weight = ", item_weight)
	
	#TODO : is exo and so what 
	var is_exo : bool = false
	
	var rune_weight_normalized : float = globals.STATS_TABLE[stat_name][rune_type[0]] * 0.02 + 0.1
	#print("rune weight pts = ", rune_weight_normalized * rune_weight_pts)
	
	#gets the total points for this click
	var total_sc_pts : float = stat_differential * stat_differential_pts 
	+ line_weight * line_weight_pts 
	+ item_weight * item_weight_pts
	+ rune_weight_normalized * rune_weight_pts
	#print("total_pts = ", total_sc_pts)
	var sc_chances : float = e ** (-((total_sc_pts - 230) ** 2) / 30400.0)
	#print("sc chances = ", sc_chances)
	
	outcome_thresholds["sc"] = int(sc_chances * 100)
	outcome_thresholds["sn"] = int((sc_chances * -0.9 + 0.9) * 100)
	#print(outcome_thresholds)



func change_runes(action : String, type_to_add : Array, line_to_add : Array, stat_name : String) -> Array:
	
	#weight to be added
	var weight_to_add : float = line_to_add[type_to_add[0]]
	
	#fm_results is [{actual_results}, is_taking_reliquat]
	var fm_results : Array
	
	match action:
		"sc":
			#adds the rune
			var raw_rune_stat_idx : int = type_to_add[1]
			var raw_rune_stat : float = line_to_add[raw_rune_stat_idx] 
			var result : Dictionary = {stat_name : raw_rune_stat}
			fm_results = [result, 0]
		"sn":
			#taking your shit
			fm_results = pick_runes(weight_to_add)
			
			#adds the rune 
			var raw_rune_stat_idx : int = type_to_add[1]
			var raw_rune_stat : float = line_to_add[raw_rune_stat_idx] 
			
			fm_results[0][stat_name] = raw_rune_stat
		"ec":
			#taking your shit
			fm_results = pick_runes(weight_to_add)
	
	
	return fm_results


func pick_runes(weight_to_add : float)-> Array:
	var fm_results : Dictionary
	
	var took_reliquat : int = 0
	var max_chances : float = 0
	var pick_chances : Dictionary
	for stat_line in i_controller.loaded_item_stats:
		if i_controller.loaded_item_stats.get(stat_line) == 0: continue
		var single_line_weight = globals.STATS_TABLE.get(stat_line)[1]
		
		var simple_weight_ratio : float = (weight_to_add / single_line_weight)
		#print(simple_weight_ratio)
		var flattened_weight : float = flatten(simple_weight_ratio)
		#print(weight_to_add / single_line_weight)
		#print(flattened_weight)
		pick_chances[stat_line] = get_gaussian_chances((flattened_weight))
		max_chances += pick_chances[stat_line]
	

	for pick_chance in pick_chances:
		pick_chances[pick_chance] = normalize_chances(pick_chances.get(pick_chance), max_chances)
	
	#print(pick_chances)
	
	var starting_reliquat = reliquat
	var current_removed_weight : float = 0
	current_removed_weight += reliquat
	
	#try to remove weight for as long as we can before exceeding equilibrium
	while current_removed_weight < weight_to_add:
		var round_seed : float = randf_range(0,1)
		var sum_of_weight : float = 0
		
		#weight random picking algo
		for stat_pick_chance in pick_chances:
			sum_of_weight += pick_chances.get(stat_pick_chance)
			if round_seed <= sum_of_weight:
				
				var picked_negative_raw_stat : float = - globals.STATS_TABLE.get(stat_pick_chance)[5]
				var picked_weight : float = globals.STATS_TABLE.get(stat_pick_chance)[1]
				
				#stops from substrating below zero
				#if stat is already near zero
				if i_controller.loaded_item_stats[stat_pick_chance] + picked_negative_raw_stat < 0:
					break
				#makes sure we don't remove too much at once
				if fm_results.get(stat_pick_chance)!= null:
					if i_controller.loaded_item_stats[stat_pick_chance] + fm_results[stat_pick_chance] < 1:
						break
				
				if fm_results.get(stat_pick_chance) == null:
					fm_results[stat_pick_chance] = picked_negative_raw_stat
				else:
					fm_results[stat_pick_chance] += picked_negative_raw_stat
				current_removed_weight += picked_weight
				break
	
	reliquat = current_removed_weight - weight_to_add
	if starting_reliquat < reliquat: took_reliquat = 1
	if starting_reliquat > reliquat: took_reliquat = -1
	#print(reliquat)
	return [fm_results, took_reliquat]

#minimize the weight f the more the line is empty
func flatten(x : float)-> float:
	if x == 0.0 : return 0.0
	var e : float = 2.71828
	var f_x : float = -(2.0 * e ) ** -( ( (x*x) / 9.68) ) + 2.0
	return f_x

func get_gaussian_chances(x : float)-> float:
	var e : float = 2.71828
	var g_x : float = (cos(PI * (x * 2)) - 1) / -2
	#gaussian distribution
	var f_x = e ** -(((x - 1.0) * (x - 1.0)) / 20.0)
	#output depending on value of x
	var p_x : float = f_x if x >= 1 else g_x
	return p_x

func normalize_chances(chance : float, total_chances : float)-> float:
	chance = chance / total_chances
	return chance
