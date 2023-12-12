extends Node2D

@onready var scene_lights: Node2D = $Lights
@onready var player: CharacterBody2D = $Player
@onready var ui: CanvasLayer = $UI


@export var level_name: String = ""

@export var shrink_rate: float = 0.4
@export var grow_rate: float = 0.2

func _ready() -> void:
	
	for light in scene_lights.get_lights():
		light.player = player
	
	Globals.set_current_scene("Level")


func is_player_in_light() -> bool:
	
	for light in scene_lights.get_lights():
		
		var dir_to_light: Vector2 = player.global_position.direction_to(light.global_position)
		
		var vec_to_player_edge_r: Vector2 = (dir_to_light.rotated(deg_to_rad(90.0))) * player.health
		var vec_to_player_edge_l: Vector2 = (dir_to_light.rotated(deg_to_rad(-90.0))) * player.health
		
		var tangent_r_start: Vector2 = player.global_position + vec_to_player_edge_r
		var tangent_l_start: Vector2 = player.global_position + vec_to_player_edge_l
		
		light.l_ray.global_position = light.global_position
		light.l_ray.target_position = light.l_ray.to_local(tangent_l_start)
		
		light.r_ray.global_position = light.global_position
		light.r_ray.target_position = light.r_ray.to_local(tangent_r_start)
		
		var is_in_light: bool = false
		
		if light.is_player_on_light() || light.l_ray.get_collider() is CharacterBody2D || light.r_ray.get_collider() is CharacterBody2D:
			
			if !light.is_spotlight:
				
				is_in_light = true
			
			else:
				
				if light.is_player_in_spotlight():
					
					is_in_light = true
		
		var is_in_range: bool = false
		
		var light_distance: float = player.global_position.distance_to(light.global_position)
		var light_range: float = ((light.texture.get_size().x / 2.0) * light.texture_scale) + player.health
		
		if light_distance < light_range:
			is_in_range = true
		
		if is_in_range && is_in_light:
			return true
	
	return false


func _physics_process(delta: float) -> void:
	
	if is_player_in_light():
		player.shrink(shrink_rate)
	else:
		if !player.is_running(): 
			player.grow(grow_rate)


func _on_no_grow_zone_player_entered(max_player_size: float) -> void:
	player.no_grow = true
	player.max_size = max_player_size


func _on_no_grow_zone_player_exited() -> void:
	player.no_grow = false
	player.max_size = player.max_health


func _on_player_death() -> void:
#	get_tree().paused = true
#	ui.game_over()
	var level_select = load("res://menus/level_select.tscn")
	get_tree().change_scene_to_packed(level_select)


func _on_finish_finished() -> void:
	
	player.disable_movement = true
	$AnimationPlayer.play("slide_transition")
#	get_tree().paused = true
	ui.game_finished()
	LevelTracker.complete_level(level_name)


func hide_lights():
	
	for light in scene_lights.get_lights():
		light.visible = false


func end_level():
	
	var level_select = load("res://menus/level_select.tscn")
	get_tree().change_scene_to_packed(level_select)
