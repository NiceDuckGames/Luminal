extends MarginContainer


func _ready() -> void:
	
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	Globals.set_current_scene("Main Menu")


func show_title():
	
	if Globals.is_startup:
		$MenuContainer/Title.visible = true
		print("startup")
	else:
		print("not startup")
		$MenuContainer/Title.visible = false


func _on_play_pressed() -> void:
	
	$AnimationPlayer.play("light off")


func _on_exit_pressed() -> void:
	
	get_tree().quit()


func set_startup_to_false():
	
	Globals.is_startup = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "light off":
		
		var level_select_scene = load("res://menus/level_select.tscn")
		get_tree().change_scene_to_packed(level_select_scene)
