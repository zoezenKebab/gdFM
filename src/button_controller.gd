extends Node

@onready var i_controller = get_parent().get_node("ItemController")
@onready var p_controller = get_parent().get_node("PuitController")
@onready var space = get_parent().get_node("FMPanel/Runes/Scroll/LinesSpace")
@onready var reliquat = get_parent().get_node("FMPanel/Puit")
@onready var historique = get_parent().get_node("FMPanel/Historique")
@onready var mouse_follow = get_parent().get_child(0).find_child("MouseFollow")

@onready var base_label = preload("res://themes/StatBase.tres")
@onready var over_label = preload("res://themes/StatOver.tres")
@onready var zero_label = preload("res://themes/StatMM.tres")
@onready var neg_label = preload("res://themes/StatMalus.tres")

@export var bg_base_color : Color
@export var bg_plus_color : Color
@export var bg_minus_color : Color
@export var historique_label : PackedScene

var last_change : Array

#type of rune : [density, actual_stat_amt]
const BUTTONS_DICT_MAP = {
	"Base" : [1,5],
	"Pa" : [2,6],
	"Ra" : [3,7]
}


func rune_pressed(type_pressed : String, stat_name : String) -> void:
	#base/pa/ra rune
	var type_to_add : Array = BUTTONS_DICT_MAP.get(type_pressed)
	#the type of stat to bed added
	var line_to_add : Array = globals.STATS_TABLE.get(stat_name)
	#the precise stat to be added
	#TODO : doit être modifié w/ succes crit/succes neutre/fail crit
	var stat_to_add : int = line_to_add[type_to_add[1]]
	
	
	
	#stops if the rune would exceed the density cap
	if p_controller.max_weight_check(stat_name, stat_to_add) == false:
		return
	
	reset_previous_click()
	
	#TODO : fix lol
	var type_of_outcome : String = p_controller.calculate_outcome(stat_name, type_to_add)
	var fm_results : Array = p_controller.change_runes(type_of_outcome, type_to_add, line_to_add, stat_name)
	var runes_to_change : Dictionary = fm_results[0]
	var took_reliquat : int = fm_results[1]
	
	for line_to_remove in runes_to_change:
		i_controller.loaded_item_stats[line_to_remove] += runes_to_change[line_to_remove]
		
		#fetches the line to be modified 
		for line in space.get_children():
			if line.get_meta("stat_name") == line_to_remove:
				line.find_child("Current").find_child("Stat").text = str(i_controller.loaded_item_stats[line_to_remove])
				
				var change_txt = "" if runes_to_change[line_to_remove] < 0 else "+"
				change_txt += str(runes_to_change[line_to_remove])
				
				line.find_child("Current").find_child("Change").text = str(change_txt)
				change_line_color(line,runes_to_change[line_to_remove])
				
				last_change.append(line)
	
	reliquat.get_child(1).get_child(0).text = str(p_controller.reliquat)
	i_controller.update_total_weight()
	create_historique(runes_to_change, took_reliquat, stat_name, type_pressed)


func reset_previous_click()-> void:
	#resets color and text of previous click
	if last_change.size() > 0:
		for line in last_change:
			line.find_child("Current").find_child("Change").text = ""
			line.get_child(0).color = bg_base_color
		last_change = []

func change_line_color(line_change : Control, change_amt : float)-> void:
	
	var changed_stat = i_controller.loaded_item_stats[line_change.get_meta("stat_name")] 
	var max_base_stat = i_controller.loaded_item_jet_theorique.get(line_change.get_meta("stat_name"))[1]
	
	var stat_amt_label = line_change.find_child("Current").find_child("Stat")
	var stat_name_label = line_change.find_child("Current").find_child("StatName")
	var stat_change = line_change.find_child("Current").find_child("Change")
	var line_bg = line_change.get_child(0)
	
	#over color
	if changed_stat > max_base_stat:
		stat_amt_label.label_settings = over_label
		stat_name_label.label_settings = over_label
	
	#normal color
	if changed_stat <= max_base_stat:
		stat_amt_label.label_settings = base_label
		stat_name_label.label_settings = base_label
	
	#0 stat color
	if changed_stat == 0:
		stat_amt_label.label_settings = zero_label
		stat_name_label.label_settings = zero_label
	
	#negative stat color
	if changed_stat < 0:
		stat_amt_label.label_settings = neg_label
		stat_name_label.label_settings = neg_label
	
	#delta stat
	if change_amt < 0:
		stat_change.label_settings = neg_label
		line_bg.color = bg_minus_color
	elif change_amt > 0:
		line_bg.color = bg_plus_color
		stat_change.label_settings = base_label

#creates a new label/bg of historique 
func create_historique(actions : Dictionary, took_reliquat : int, click_stat : String, type_click : String)-> void:
	var new_label = historique_label.instantiate()
	
	historique.get_child(0).get_child(0).add_child(new_label)
	new_label.text = "       "
	var control_chances = "sc : " + str(p_controller.outcome_thresholds["sc"]) + "%, "
	control_chances += "sn : " + str(p_controller.outcome_thresholds["sn"] - p_controller.outcome_thresholds["sc"]) + "%, "
	control_chances += "ec : " + str(100 - p_controller.outcome_thresholds["sn"]) + "%"
	
	new_label.set_meta("outcome_chances", control_chances)
	new_label.mouse_entered.connect(mouse_follow.show_stats.bind(new_label.get_meta("outcome_chances")))
	#new_label.mouse_entered.connect(mouse_follow.foo)
	
	for action in actions:
		var raw_action : String = str(actions[action]) + " " + action
		if actions[action] > 0: 
			raw_action = raw_action.insert(0, "+") 
			raw_action = raw_action.insert(0, "[color=lime_green]")
			raw_action = raw_action.insert(raw_action.length(), "[/color]")
		else:
			raw_action = raw_action.insert(0, "[color=firebrick]")
			raw_action = raw_action.insert(raw_action.length(), "[/color]")
		new_label.text += raw_action + " "
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if took_reliquat == -1: new_label.text += "[color=red]-reliquat[/color]"
	elif took_reliquat == 1:  new_label.text += "[color=green]+reliquat[/color]"
	
	new_label.get_child(1).size = new_label.size
	var type_click_id : int = 0
	match type_click:
		"Base" : type_click_id = 0
		"Pa" : type_click_id = 1
		"Ra" : type_click_id = 2
	i_controller.set_rune_icon(new_label.get_child(0), click_stat, type_click_id)
	
	#I wanna see my new label plzzz, (must wait for frame to process)
	await get_tree().process_frame
	historique.get_child(0).ensure_control_visible(new_label)

func delete_historique()-> void:
	reliquat.get_child(1).get_child(0).text = "0"
	for child in historique.get_child(0).get_child(0).get_children():
		child.queue_free()

func white_flash(button : Control, entered : bool)-> void:
	if entered: button.get_child(0).modulate.v = 15
	else: button.get_child(0).modulate.v = 1

func confirm_click(button : Control)-> void:
	button.scale = Vector2(0.9,0.9)
	button.get_child(0).scale = Vector2(1.1,1.1)
	await get_tree().create_timer(0.1).timeout
	button.scale = Vector2(1,1)
	button.get_child(0).scale = Vector2(1,1)
