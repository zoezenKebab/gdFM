extends Control

@onready var wdw_popup = get_parent().find_child("WindowPopup")
@onready var i_controller =  get_parent().find_child("ItemController")
@onready var items = get_parent().find_child("Items")
@onready var infos = find_child("Item")
@onready  var exos = find_child("ExoButtons")

var items_atlas = preload("res://texts/atlas_items.png")


func item_button_master()-> void:
	wdw_popup.show()
	wdw_popup.title = "OBJETS DISPONIBLES"
	var i = 0
	for item in items.i_list:
		var item_button = Button.new()
		#item_button.flat = true
		item_button.tooltip_text = item["name"]
		
		var button_atlas = AtlasTexture.new()
		button_atlas.atlas = items_atlas
		button_atlas.region = Rect2(item["icon_offset"].x,item["icon_offset"].y,73,73)
		item_button.icon = button_atlas
		item_button.expand_icon = true
		
		item_button.custom_minimum_size = Vector2(60,60)
		item_button.pressed.connect(open_item.bind(i))
		wdw_popup.get_child(0).add_child(item_button)
		i += 1

func close_popup()-> void:
	for child in wdw_popup.get_child(0).get_children():
		child.queue_free()

func open_item(item_dict_idx : int)-> void:
	var item_dict : Dictionary = items.i_list[item_dict_idx]
	i_controller.load_item_stats(item_dict["jet"])
	infos.get_child(0).text = item_dict["name"]
	
	var master_atlas = AtlasTexture.new()
	master_atlas.atlas = items_atlas
	master_atlas.region = Rect2(item_dict["icon_offset"].x,item_dict["icon_offset"].y,73,73)
	infos.get_child(1).icon = master_atlas
	wdw_popup.hide()
	
	if find_child("Menu").get_child(1).disabled: find_child("Menu").get_child(1).disabled = false
	
	close_popup()
	pass

func show_exo_panel()-> void:
	if exos.get_child(0).is_visible():
		exos.get_child(0).hide()
	else:
		exos.get_child(0).show()
