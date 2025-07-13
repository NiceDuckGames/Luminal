extends MarginContainer


var to_scene: String = ""

func _ready() -> void:
	
	$MenuContainer/HBoxContainer/Play.grab_focus()
	Globals.set_current_scene("Main Menu")


func show_title():
	
	if Globals.is_startup:
		$MenuContainer/Title.visible = true
		
	else:
		$MenuContainer/Title.visible = false


func _on_play_pressed() -> void:
	
	$AnimationPlayer.play("light off")
	to_scene = "Level Select"


func _on_settings_pressed() -> void:
	$AnimationPlayer.play("light off")
	to_scene = "Settings"


func _on_exit_pressed() -> void:
	
	get_tree().quit()


func set_startup_to_false():
	
	Globals.is_startup = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "light off":
		
		if to_scene == "Level Select":
			var level_select_scene = load("res://menus/level_select.tscn")
			get_tree().change_scene_to_packed(level_select_scene)
		elif to_scene == "Settings":
			var settings_scene = load("res://menus/settings.tscn")
			get_tree().change_scene_to_packed(settings_scene)
		elif to_scene == "Credits":
			var credits_scene = load("res://menus/credits.tscn")
			get_tree().change_scene_to_packed(credits_scene)


func _on_credits_pressed() -> void:
	$AnimationPlayer.play("light off")
	to_scene = "Credits"
