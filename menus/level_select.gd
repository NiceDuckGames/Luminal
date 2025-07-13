extends MarginContainer


var level_item_res: PackedScene = preload("res://menus/level_select_item.tscn")
@onready var item_container: GridContainer = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer


var levels: Array = []
var level_items: Array = []


func _ready() -> void:
	
	var da: DirAccess = DirAccess.open("res://levels")
	
	if da:
		
		da.list_dir_begin()
		
		var file_name = da.get_next()
		
		while file_name != "":
			
			if file_name == "0_how_make_level.txt":
				file_name = da.get_next()
				continue
			
			if !da.current_is_dir():
				
				var item = level_item_res.instantiate()
				
				item.set_level_name(file_name.get_basename().get_basename())
				item.level_file_path = "res://levels/" + file_name
				
				if LevelTracker.is_level_completed(file_name.get_basename().get_basename()):
					item.set_completed()
				
				levels.push_back(file_name.get_basename().get_basename())
				level_items.push_back(item)
			
			file_name = da.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	levels.sort_custom(sort_numerical)
	
	var previous_level_item: Control = null
	
	for level_name in levels:
		
		for level_item in level_items:
			
			if level_item.level_name == level_name:
				
				item_container.add_child(level_item)
				
				if previous_level_item:
					level_item.focus_neighbor_left = previous_level_item.get_path()
					previous_level_item.focus_neighbor_right = level_item.get_path()
				else:
					level_item.focus_neighbor_left = $MarginContainer/PanelContainer/VBoxContainer/Control/BackButton.get_path()
					$MarginContainer/PanelContainer/VBoxContainer/Control/BackButton.focus_neighbor_right = level_item.get_path()
					
				previous_level_item = level_item
	
	if !LevelTracker.is_set_up():
		
		LevelTracker.setup_levels(levels)
	
	Globals.set_current_scene("Level Select")


func sort_numerical(a: String, b: String):
	
	if int(a) < int(b):
		return true
	return false


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
	$MarginContainer/PanelContainer/VBoxContainer/Control/BackButton.grab_focus()
	


func _on_back_button_pressed() -> void:
	
	$AnimationPlayer.play("back_transition")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "back_transition":
		
		var main_menu = load("res://menus/main_menu.tscn")
		get_tree().change_scene_to_packed(main_menu)


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		
		if $MarginContainer/PanelContainer/VBoxContainer/Control/BackButton.has_focus():
			self.grab_focus()
		
		for level_item in level_items:
			if level_item.has_focus():
				self.grab_focus()
