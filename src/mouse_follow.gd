extends Label




func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position() + Vector2(-30,-40)

func show_stats(hist_text : String) -> void:
	show()
	
	text = hist_text

func exit_histo()-> void:
	hide()
	pass
