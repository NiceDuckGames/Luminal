extends MarginContainer


@onready var music_volume: HSlider = $VBoxContainer/MarginContainer/HBoxContainer/MusicVolume
@onready var effects_volume: HSlider = $VBoxContainer/MarginContainer2/HBoxContainer/EffectVolume
@onready var up_button: Button = $VBoxContainer/MarginContainer4/VBoxContainer/HBoxContainer/Up
@onready var down_button: Button = $VBoxContainer/MarginContainer4/VBoxContainer/HBoxContainer2/Down
@onready var left_button: Button = $VBoxContainer/MarginContainer4/VBoxContainer/HBoxContainer3/Left
@onready var right_button: Button = $VBoxContainer/MarginContainer4/VBoxContainer/HBoxContainer4/Right
@onready var exit_level_button: Button = $VBoxContainer/MarginContainer4/VBoxContainer/HBoxContainer5/ExitLevel

var active_input_selection: Button = null


func _ready() -> void:
	
	up_button.text = InputMap.action_get_events("Up")[0].as_text_physical_keycode()
	down_button.text = InputMap.action_get_events("Down")[0].as_text_physical_keycode()
	left_button.text = InputMap.action_get_events("Left")[0].as_text_physical_keycode()
	right_button.text = InputMap.action_get_events("Right")[0].as_text_physical_keycode()
	exit_level_button.text = InputMap.action_get_events("ExitLevel")[0].as_text_physical_keycode()
	
	music_volume.set_value_no_signal(AudioServer.get_bus_volume_db(2))
	effects_volume.set_value_no_signal(AudioServer.get_bus_volume_db(1))
	
	$Control/BackButton.grab_focus()
	
	Globals.set_current_scene("Settings")

func _on_music_volume_value_changed(value: float) -> void:
	
	AudioServer.set_bus_volume_db(2, value)


func _on_effect_volume_value_changed(value: float) -> void:
	
	AudioServer.set_bus_volume_db(1, value)


func _on_effect_volume_drag_ended(value_changed: bool) -> void:
	$AudioStreamPlayer2.play()


func _on_up_button_down() -> void:
	active_input_selection = up_button


func _on_down_button_down() -> void:
	active_input_selection = down_button


func _on_left_button_down() -> void:
	active_input_selection = left_button


func _on_right_button_down() -> void:
	active_input_selection = right_button


func _on_exit_level_button_down() -> void:
	active_input_selection = exit_level_button


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		
		self.grab_focus()
	
	if event is InputEventKey && !event.is_pressed() && !event.is_action("ui_accept"):
		
		match active_input_selection:
			
			up_button:
				
				InputMap.action_erase_events("Up")
				InputMap.action_add_event("Up", event)
				up_button.text = event.as_text_keycode()
				up_button.set_pressed_no_signal(false)
			
			down_button:
				
				InputMap.action_erase_events("Down")
				InputMap.action_add_event("Down", event)
				down_button.text = event.as_text_keycode()
				down_button.set_pressed_no_signal(false)
			
			left_button:
				
				InputMap.action_erase_events("Left")
				InputMap.action_add_event("Left", event)
				left_button.text = event.as_text_keycode()
				left_button.set_pressed_no_signal(false)
			
			right_button:
				
				InputMap.action_erase_events("Right")
				InputMap.action_add_event("Right", event)
				right_button.text = event.as_text_keycode()
				right_button.set_pressed_no_signal(false)
			
			exit_level_button:
				
				InputMap.action_erase_events("ExitLevel")
				InputMap.action_add_event("ExitLevel", event)
				exit_level_button.text = event.as_text_keycode()
				exit_level_button.set_pressed_no_signal(false)
			
			_:
				
				return
		
		active_input_selection = null
	
	if event is InputEventKey && event.is_pressed() && event.as_text_keycode().find("+") != -1:
		
		match active_input_selection:
			
			up_button:
				
				InputMap.action_erase_events("Up")
				InputMap.action_add_event("Up", event)
				up_button.text = event.as_text_keycode()
				up_button.set_pressed_no_signal(false)
			
			down_button:
				
				InputMap.action_erase_events("Down")
				InputMap.action_add_event("Down", event)
				down_button.text = event.as_text_keycode()
				down_button.set_pressed_no_signal(false)
			
			left_button:
				
				InputMap.action_erase_events("Left")
				InputMap.action_add_event("Left", event)
				left_button.text = event.as_text_keycode()
				left_button.set_pressed_no_signal(false)
			
			right_button:
				
				InputMap.action_erase_events("Right")
				InputMap.action_add_event("Right", event)
				right_button.text = event.as_text_keycode()
				right_button.set_pressed_no_signal(false)
			
			exit_level_button:
				
				InputMap.action_erase_events("ExitLevel")
				InputMap.action_add_event("ExitLevel", event)
				exit_level_button.text = event.as_text_keycode()
				exit_level_button.set_pressed_no_signal(false)
			
			_:
				
				return
		
		active_input_selection = null


func return_to_main_screen():
	
	var main_screen: PackedScene = load("res://menus/main_menu.tscn")
	get_tree().change_scene_to_packed(main_screen)


func _on_back_button_pressed() -> void:
	
	$AnimationPlayer.play("go_back")
