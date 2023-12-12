extends MarginContainer


var level_item_res: PackedScene = preload("res://menus/level_select_item.tscn")
@onready var item_container: HFlowContainer = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer


var levels: PackedStringArray = []


func _ready() -> void:
	
	var da: DirAccess = DirAccess.open("res://levels")
	
	if da:
		
		da.list_dir_begin()
		
		var file_name = da.get_next()
		
		while file_name != "":
			
			if !da.current_is_dir():
				
				var item = level_item_res.instantiate()
				
				item.set_level_name(file_name.get_basename().get_basename())
				item.level_file_path = "res://levels/" + file_name.get_basename()
				
				if LevelTracker.is_level_completed(file_name.get_basename().get_basename()):
					item.set_completed()
				
				item_container.add_child(item)
				
				levels.push_back(file_name.get_basename().get_basename())
			
			file_name = da.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	if !LevelTracker.is_set_up():
		
		LevelTracker.setup_levels(levels)
	
	Globals.set_current_scene("Level Select")


func show_title():
	
	if Globals.previous_scene == "Main Menu":
		print("show title")
		$Control/Title.visible = true
	else:
		$Control/Title.visible = false
		$ColorRect.color = Color.from_string("1d1d22", Color.BLACK)


func hide_title():
	
	$Control/Title.visible = false
	$ColorRect.color = Color.from_string("45454e", Color.BLACK)


func _on_back_button_pressed() -> void:
	
	$AnimationPlayer.play("back_transition")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "back_transition":
		
		var main_menu = load("res://menus/main_menu.tscn")
		get_tree().change_scene_to_packed(main_menu)
