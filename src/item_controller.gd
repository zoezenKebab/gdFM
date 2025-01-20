extends Node

@export var line : PackedScene

@onready var space = get_parent().get_node("FMPanel/Runes/Scroll/LinesSpace")
@onready var bad_stat = preload("res://themes/StatMalus.tres")
@onready var b_controller = get_parent().get_node("ButtonController")
@onready var p_controller =  get_parent().get_node("PuitController")
@onready var puit = get_parent().get_node("FMPanel/Puit")

var loaded_item_stats : Dictionary

var loaded_item_jet_theorique : Dictionary

var item_weight : float = 0


func load_item_stats(jet : Dictionary)-> void:
	reset_buttons()
	
	loaded_item_jet_theorique = jet
	
	for stat in loaded_item_jet_theorique:
		var new_line = line.instantiate()
		var is_stat_neg : bool = false
		if loaded_item_jet_theorique.get(stat)[0] < 1 or loaded_item_jet_theorique.get(stat)[1] < 1:
			is_stat_neg = true
		
		#name of the stat
		new_line.set_meta("stat_name", stat)
		
		#min-max jets
		var min_stat = str(loaded_item_jet_theorique.get(stat)[0])
		var max_stat = str(loaded_item_jet_theorique.get(stat)[1])
		
		#display min and max of the line
		new_line.find_child("MinMax").text = min_stat + " - " + max_stat
		#edge case : if stat is fixed
		if max_stat == min_stat: new_line.find_child("MinMax").text = min_stat
		
		#initialize item with random stat
		var stat_r = randi_range(int(min_stat),int(max_stat))
		loaded_item_stats[stat] = stat_r
		new_line.find_child("Current").find_child("Stat").text = str(loaded_item_stats.get(stat))
		if is_stat_neg: new_line.find_child("Current").find_child("Stat").label_settings = bad_stat
		
		
		
		
		#stat name
		new_line.find_child("Current").find_child("StatName").text = globals.STATS_TABLE.get(stat)[0]
		if is_stat_neg: new_line.find_child("Current").find_child("StatName").label_settings = bad_stat
		
		#pa/ra buttons
		if globals.STATS_TABLE.get(stat)[2] == 0: new_line.find_child("Runes").find_child("Pa").queue_free()
		if globals.STATS_TABLE.get(stat)[3] == 0: new_line.find_child("Runes").find_child("Ra").queue_free()
		
		#change change labels
		new_line.find_child("Current").find_child("Change").text = ""
		
		#connect buttons
		for button in new_line.find_child("Runes").get_children():
			button.connect("pressed", b_controller.rune_pressed.bind(button.name, new_line.get_meta("stat_name")))
		
		#add line to item hud
		space.add_child(new_line)
	
	update_total_weight()

func update_total_weight()-> void:
	#displays the curent weight of the item
	puit.get_child(0).get_child(0).text = str(get_total_weight(false))

func get_total_weight(is_max : bool)-> float:
	item_weight = 0
	for stat in loaded_item_jet_theorique:
	#calculate starting weight
		item_weight += get_line_weight(stat, is_max)
	
	return item_weight



#TODO : AU SECOUR REFAIRE ALED
var special_weights = ["pod", "vi", "ini"]

func get_line_weight(stat : String, is_max : bool) -> float:
	#weight of a single rune
	var rune_weight : int = globals.STATS_TABLE.get(stat)[1]
	#the stat currently being modified
	var current_stat = loaded_item_stats.get(stat) if !is_max else loaded_item_jet_theorique[stat][1]
	var total_line_weight : float = 0
	
	
	#usual case, single rune weight is > 1 and stat is not negative
	if special_weights.find(stat) == -1:
		total_line_weight += current_stat * rune_weight
		return total_line_weight
	
	
	#TODO : what if negative and special ???
	
	#negative stat case
	if loaded_item_stats.get(stat) < 0:
		
		#TODO : need to handle negative stat to 0 and up
		
		var min_stat = loaded_item_jet_theorique.get(stat)[0]
		total_line_weight += abs(min_stat - current_stat) / 2.0
		return total_line_weight
	
	#pods
	if special_weights.find(stat) == 0:
		total_line_weight += current_stat * 0.25
		return total_line_weight
	
	#vitalité
	if special_weights.find(stat) == 1:
		total_line_weight += current_stat * 0.2
		return total_line_weight
	
	#initiative
	if special_weights.find(stat) == 2:
		total_line_weight += current_stat * 0.1
		return total_line_weight
	
	return -1


func reset_loaded_item_jet()-> void:
	if loaded_item_stats.is_empty(): return 
	
	for stat_line in loaded_item_stats:
		var new_stat = randi_range(loaded_item_jet_theorique.get(stat_line)[0],loaded_item_jet_theorique.get(stat_line)[1])
		loaded_item_stats[stat_line] = new_stat
		for line_hud in space.get_children():
			if line_hud.get_meta("stat_name") == stat_line:
				line_hud.find_child("Current").find_child("Stat").text = str(loaded_item_stats[stat_line])
				b_controller.change_line_color(line_hud, 0.0)
				b_controller.reset_previous_click()
				b_controller.delete_historique()
				p_controller.reliquat = 0
	get_total_weight(false)

func reset_buttons()-> void:
	if space.get_child_count() == 0: return
	b_controller.last_change = []
	loaded_item_stats = {}
	b_controller.delete_historique()
	p_controller.reliquat = 0
	for child in space.get_children():
		child.queue_free()
