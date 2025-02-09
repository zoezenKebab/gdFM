extends Node

@onready var i_controller = get_parent().get_node("ItemController")

## checks first and independently from the other
## where x = line_stat / (rune_stat * 20)
@export var rune_to_stat_curve : Curve

## where  x = (line_stat / line_max) / 3.0
## so 1 = 3 * max
@export var line_fullness_curve : Curve

## where x = rune_weight / 100
## so 1 = GaPA 
@export var rune_weight_curve : Curve

## where x = (item_weight / item_max_weight) / 2
## so 1  = 2 * max
@export var item_fullness_curve : Curve

@export var weights_curve : Curve
@export var sn_curve : Curve


var reliquat : float = 0


func max_weight_check(stat_line : String, amount : int) -> bool:
	
	# the weight of the line would the rune pass
	var wanted_weight = i_controller.loaded_item_jet.get(stat_line) + amount
	var check_passed : bool = true
	# checks if the wanted weight > rune cap
	if wanted_weight > globals.STATS_TABLE.get(stat_line)[4]:
		check_passed = false
		
		# but if the max of the item exceeds the rune ca^p, overides it
		if wanted_weight <= i_controller.loaded_item_jet_theorique.get(stat_line)[1]:
			check_passed = true
	
	return check_passed


# % chances of outcome "sc" = succes_crit, "sn" = succes_neutre, "ec" = echec_crit
var outcome_thresholds : Dictionary = {"sc" : 10, "sn" : 80, "ec" : 100}

func calculate_outcome(stat_name : String, rune_type : Array)-> String:
	#the runes that will be removed/added
	#var fm_results : Dictionary
	
	# the key pointing to the dict of thresholds
	var outcome_key : String
	
	# updates the thresholds based on item_stats and wanted_rune
	update_outcome_thresholds(stat_name, rune_type)
	
	var outcome_r : int = randi_range(0,100)
	# loops through the thresholds from small to big
	# if found rand_i < threshold, break and return threshold
	for threshold in outcome_thresholds:
		if outcome_r <= outcome_thresholds.get(threshold):
			outcome_key = threshold
			break
	
	return outcome_key

func update_outcome_thresholds(stat_name : String, rune_type : Array)-> void:
	#WARNING : if is exo = crash
	var current_min : float = 1
	
	var current_stat : float = i_controller.loaded_item_jet[stat_name]
	var rune_stat : float = globals.STATS_TABLE[stat_name][rune_type[1]]
	var line_stat_max : float = i_controller.loaded_item_jet_theorique[stat_name][1]
	var rune_weight : float = globals.STATS_TABLE[stat_name][rune_type[0]]
	var item_weight : float = i_controller.get_total_weight(false)
	var item_weight_max : float = i_controller.get_total_weight(true)
	
	var sc0 : float = rune_to_stat_curve.sample(current_stat / (rune_stat * 20.0))
	if sc0 < current_min: current_min = sc0
	
	var sc1 : float = line_fullness_curve.sample((current_stat / line_stat_max) / 3.0) 
	if sc1 < current_min: current_min = sc1
	
	var sc2 : float = rune_weight_curve.sample(rune_weight / 100.0)
	if sc2 < current_min: current_min = sc2
	
	var sc3 : float = item_fullness_curve.sample((item_weight / item_weight_max) / 2)
	if sc3 < current_min: current_min = sc3
	
	var sc_final : float = weights_curve.sample(current_min)
	var sn : float = sn_curve.sample(sc_final)
	
	outcome_thresholds["sc"] = int(sc_final * 100)
	outcome_thresholds["sn"] = int(sn * 100)



func change_runes(action : String, type_to_add : Array, line_to_add : Array, stat_name : String) -> Array:
	
	# weight to be added
	var weight_to_add : float = line_to_add[type_to_add[0]]
	
	# fm_results is [{actual_results}, is_taking_reliquat]
	var fm_results : Array
	
	match action:
		"sc":
			# adds the rune
			var raw_rune_stat_idx : int = type_to_add[1]
			var raw_rune_stat : float = line_to_add[raw_rune_stat_idx] 
			var result : Dictionary = {stat_name : raw_rune_stat}
			fm_results = [result, 0]
		"sn":
			# taking your shit
			fm_results = pick_runes(weight_to_add, stat_name)
			
			# adds the rune 
			var raw_rune_stat_idx : int = type_to_add[1]
			var raw_rune_stat : float = line_to_add[raw_rune_stat_idx] 
			
			fm_results[0][stat_name] = raw_rune_stat
		"ec":
			# taking your shit
			fm_results = pick_runes(weight_to_add, "NONE")
	
	
	return fm_results


func pick_runes(weight_to_add : float, stat_added : String)-> Array:
	var fm_results : Dictionary
	
	var took_reliquat : int = 0
	var max_chances : float = 0
	var pick_chances : Array[Array]
	
	# calculates the pick chances of the runes
	for stat_line in i_controller.loaded_item_jet:
		# prevents picking on lines that are equal to 0
		# by just skipping them and not adding them to the pick_chances dictionary
		if i_controller.loaded_item_jet.get(stat_line) < 0: continue
		
		
		# the density of a single rune of the line
		var single_line_weight : float = globals.STATS_TABLE.get(stat_line)[1]
		
		# the density of the added rune divided by the density of the line
		var simple_weight_ratio : float = (weight_to_add / single_line_weight)
		
		# stat_block is : [line_name, line_pick_chance]
		var stat_block = [stat_line, get_gaussian_chances(simple_weight_ratio)]
		var axtual_to_max_ratio = i_controller.loaded_item_jet.get(stat_line) / i_controller.loaded_item_jet_theorique.get(stat_line)[1]
		if axtual_to_max_ratio > 1:
			stat_block[1] = no_more_over(axtual_to_max_ratio) 
		if stat_block[1] < 0.2 : stat_block[1] += 0.2
		pick_chances.append(stat_block)
		
		max_chances += stat_block[1]
	
	# normalize the pick chances so that they all add up to one
	for stat_block_chance in pick_chances:
		stat_block_chance[1] = normalize_chances(stat_block_chance[1], max_chances)
	
	pick_chances.sort_custom(sort_ascending)
	
	var starting_reliquat : float = reliquat
	var current_removed_weight : float = 0
	current_removed_weight += reliquat
	
	# try to remove weight for as long as we can before exceeding equilibrium
	while current_removed_weight < weight_to_add:
		var round_seed : float = randf_range(0,100)
		var sum_of_weight : float = 0
		
		# weight random picking algo
		for stat_block_chance in pick_chances:
			
			var stat_pick_chance = stat_block_chance[1]
			var stat_pick_name = stat_block_chance[0]
			sum_of_weight += stat_pick_chance
			
			if round_seed <= sum_of_weight:
				
				var over_bonus : float = 1.0
				if i_controller.loaded_item_jet.get(stat_pick_name) > i_controller.loaded_item_jet_theorique.get(stat_pick_name)[1]:
					over_bonus = 4.0
				
				var picked_negative_raw_stat : float = - globals.STATS_TABLE.get(stat_pick_name)[5] * over_bonus
				var picked_weight : float = globals.STATS_TABLE.get(stat_pick_name)[1] * over_bonus
				
				# picks a random number if minimum_rune_stat < 1
				if i_controller.special_weights.has(stat_pick_name):
					picked_negative_raw_stat = randi_range(1,globals.STATS_TABLE.get(stat_pick_name)[5])
					picked_weight = globals.STATS_TABLE.get(stat_pick_name)[1] / picked_negative_raw_stat
					
					picked_negative_raw_stat = - picked_negative_raw_stat * over_bonus
					picked_weight = picked_weight * over_bonus
				
				# stops from substrating below zero
				# if stat is already near zero
				if i_controller.loaded_item_jet[stat_pick_name] + picked_negative_raw_stat < 0:
					break
				# makes sure we don't remove too much at once
				if fm_results.get(stat_pick_name) != null:
					if i_controller.loaded_item_jet[stat_pick_name] + fm_results[stat_pick_name] < 1:
						break
				
				if fm_results.get(stat_pick_name) == null:
					fm_results[stat_pick_name] = picked_negative_raw_stat
				else:
					fm_results[stat_pick_name] += picked_negative_raw_stat
				current_removed_weight += picked_weight
				break
	
	reliquat = current_removed_weight - weight_to_add
	if starting_reliquat < reliquat: took_reliquat = 1
	if starting_reliquat > reliquat: took_reliquat = -1
	return [fm_results, took_reliquat]

func rune_standalone(pick_chances : Array, stat_added : String)-> bool:
	if pick_chances.size() != 0:
		for stat_block in pick_chances:
			if stat_block[0] == stat_added:
				return true
	return false

func sort_ascending(a : Array, b : Array)-> bool:
	if a[1] < b[1]:
		return true
	return false

# minimize the weight f the more the line is empty
func no_more_over(x : float)-> float:
	if x == 0.0 : return 0.0
	#var e : float = 2.71828
	var f_x : float = x * (2 - 2 ** (-5 * x + 5))
	return f_x

func get_gaussian_chances(x : float)-> float:
	var e : float = 2.71828
	var g_x : float = 1 - 2 ** (-5.5 * x)
	#gaussian distribution
	var f_x = e ** -(((x - 1.0) * (x - 1.0)) / 20.0)
	#output depending on value of x
	var p_x : float = f_x if x >= 1 else g_x
	return p_x

func normalize_chances(chance : float, total_chances : float)-> float:
	chance = (chance / total_chances ) * 100.0
	return chance 
