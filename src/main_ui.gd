extends Control

@onready var item_popup = get_parent().find_child("ItemPopup")
@onready var i_controller =  get_parent().find_child("ItemController")
@onready var items = get_parent().find_child("Items")
@onready var infos = get_child(0)

var items_atlas = preload("res://texts/icon_atlas.png")

func item_button_master()-> void:
	item_popup.show()
	var i = 0
	for item in items.i_list:
		var item_button = Button.new()
		item_button.flat = true
		
		var button_atlas = AtlasTexture.new()
		button_atlas.atlas = items_atlas
		button_atlas.region = Rect2(item["icon_offset"].x,item["icon_offset"].y,100,100)
		item_button.icon = button_atlas
		item_button.custom_minimum_size = Vector2(100,100)
		item_button.pressed.connect(open_item.bind(i))
		item_popup.get_child(0).add_child(item_button)
		i += 1

func close_popup()-> void:
	for child in item_popup.get_child(0).get_children():
		child.queue_free()

func open_item(item_dict_idx : int)-> void:
	var item_dict : Dictionary = items.i_list[item_dict_idx]
	i_controller.load_item_stats(item_dict["jet"])
	infos.get_child(0).text = item_dict["name"]
	
	var master_atlas = AtlasTexture.new()
	master_atlas.atlas = items_atlas
	master_atlas.region = Rect2(item_dict["icon_offset"].x,item_dict["icon_offset"].y,100,100)
	infos.get_child(1).icon = master_atlas
	item_popup.hide()
	close_popup()
	pass
