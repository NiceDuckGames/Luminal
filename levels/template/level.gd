extends Node2D

@onready var scene_lights: Node2D = $Lights
@onready var player: CharacterBody2D = $Player
@onready var ui: CanvasLayer = $UI
@onready var level_boundary: Node2D = $LevelGeometry/Boundary
@onready var level_walls: Node2D = $LevelGeometry/Walls
@onready var background_color: ColorRect = $Background/BackgroundColor


@export var level_name: String = ""

@export var shrink_rate: float = 0.4
@export var grow_rate: float = 0.2

var is_dark_mode: bool = false

func _ready() -> void:
	
	for light in scene_lights.get_lights():
		light.player = player
	
	Globals.set_current_scene("Level")


func is_player_in_light() -> bool:
	
	for light in scene_lights.get_lights():
		
		if !light.visible:
			continue
		
		
		var is_in_range: bool = false
		
		var light_distance: float = player.global_position.distance_to(light.global_position)
		var light_range: float = ((light.texture.get_size().x / 2.0) * light.texture_scale) + player.health
		
		if light_distance < light_range:
			
			is_in_range = true
		
		else: continue
		
		
		var dir_to_light: Vector2 = player.global_position.direction_to(light.global_position)
		
		var vec_to_player_edge_r: Vector2 = (dir_to_light.rotated(deg_to_rad(90.0))) * player.health
		var vec_to_player_edge_l: Vector2 = (dir_to_light.rotated(deg_to_rad(-90.0))) * player.health
		
		var tangent_r_start: Vector2 = player.global_position + vec_to_player_edge_r
		var tangent_l_start: Vector2 = player.global_position + vec_to_player_edge_l
		
		light.l_ray.global_position = light.global_position
		light.l_ray.target_position = light.l_ray.to_local(tangent_l_start)
		
		light.r_ray.global_position = light.global_position
		light.r_ray.target_position = light.r_ray.to_local(tangent_r_start)
		
		light.c_ray.global_position = light.global_position
		light.c_ray.target_position = light.c_ray.to_local(player.global_position)
		
		var is_in_light: bool = false
		
		if light.is_player_on_light() || light.c_ray.get_collider() is CharacterBody2D || light.l_ray.get_collider() is CharacterBody2D || light.r_ray.get_collider() is CharacterBody2D:
			
			if !light.is_spotlight:
				
				is_in_light = true
			
			else:
				
				if light.is_player_in_spotlight():
					
					is_in_light = true
		
		if is_in_range && is_in_light:
			return true
	
	return false


func is_player_in_light_dark_mode():
	
	var out_of_range_lights: Array[bool] = []
	var unobscured_lights: Array[bool] = []
	var partially_obscured_lights: Array[bool] = []
	var completely_obscured_lights: Array[bool] = []
	
	var scene_light_nodes: Array[Node] = scene_lights.get_lights()
	
	for i in range(scene_light_nodes.size()):
		
		var light = scene_light_nodes[i]
		
		var light_distance: float = player.global_position.distance_to(light.global_position)
		var light_range: float = ((light.texture.get_size().x / 2.0) * light.texture_scale) + player.health
		
		light_range -= player.health * 2
		
		if light_distance > light_range:
			out_of_range_lights.push_back(true)
		else:
			out_of_range_lights.push_back(false)
		
		# Cast Rays
		var dir_to_light: Vector2 = player.global_position.direction_to(light.global_position)
		
		var vec_to_player_edge_r: Vector2 = (dir_to_light.rotated(deg_to_rad(90.0))) * player.health
		var vec_to_player_edge_l: Vector2 = (dir_to_light.rotated(deg_to_rad(-90.0))) * player.health
		
		var tangent_r_start: Vector2 = player.global_position + vec_to_player_edge_r
		var tangent_l_start: Vector2 = player.global_position + vec_to_player_edge_l
		
		light.l_ray.global_position = light.global_position
		light.l_ray.target_position = light.l_ray.to_local(tangent_l_start)
		
		light.r_ray.global_position = light.global_position
		light.r_ray.target_position = light.r_ray.to_local(tangent_r_start)
		
		light.c_ray.global_position = light.global_position
		light.c_ray.target_position = light.c_ray.to_local(player.global_position)
		
		# Light completely obscured
		if !(light.l_ray.get_collider() is CharacterBody2D) && !(light.r_ray.get_collider() is CharacterBody2D) && !(light.c_ray.get_collider() is CharacterBody2D):
			
			completely_obscured_lights.push_back(true)
			partially_obscured_lights.push_back(false)
			unobscured_lights.push_back(false)
			
		
		# Light completely unobscured
		elif light.l_ray.get_collider() is CharacterBody2D && light.r_ray.get_collider() is CharacterBody2D && light.c_ray.get_collider() is CharacterBody2D:
			
			if !light.is_spotlight:
				
				unobscured_lights.push_back(true)
				completely_obscured_lights.push_back(false)
				partially_obscured_lights.push_back(false)
			
			else:
				
				if light.is_player_in_spotlight():
					
					unobscured_lights.push_back(true)
					completely_obscured_lights.push_back(false)
					partially_obscured_lights.push_back(false)
				
				else:
					
					completely_obscured_lights.push_back(true)
					partially_obscured_lights.push_back(false)
					unobscured_lights.push_back(false)
		
		# Light partially obscured
		elif light.l_ray.get_collider() is CharacterBody2D || light.r_ray.get_collider() is CharacterBody2D || light.c_ray.get_collider() is CharacterBody2D:
			
			if !light.is_spotlight:
				
				partially_obscured_lights.push_back(true)
				unobscured_lights.push_back(false)
				completely_obscured_lights.push_back(false)
			
			else:
				
				if light.is_player_in_spotlight():
					
					partially_obscured_lights.push_back(true)
					unobscured_lights.push_back(false)
					completely_obscured_lights.push_back(false)
				
				else:
					
					partially_obscured_lights.push_back(false)
					unobscured_lights.push_back(false)
					completely_obscured_lights.push_back(true)
			
			
	
	# Out of range of all
	if out_of_range_lights.all(all_lights_out_of_range):
		return true
	
	# In range of any
	if out_of_range_lights.any(any_lights_in_range):
		
		var lights_in_range: Array[int] = []
		
		# In range of at least one:
		for i in range(scene_light_nodes.size()):
			
			# In range:
			if out_of_range_lights[i] == false:
				
				lights_in_range.push_back(i)
		
		
		# If any lights are unobscured
		for light_index in lights_in_range:
			
			if unobscured_lights[light_index] == true:
				
				if !scene_light_nodes[light_index].is_spotlight:
					
					return false
				
				else:
					
					if scene_light_nodes[light_index].is_player_in_spotlight():
						
						return false
		
		
		var all_completely_obscured: bool = true
		
		for light_index in lights_in_range:
			
			# Check if all lights are blocked
			if completely_obscured_lights[light_index] == false:
				
				all_completely_obscured = false
		
		if all_completely_obscured:
			
			return true
		
		
		for light_index in lights_in_range:
			
			# Skip light if it's not visible
			if !scene_light_nodes[light_index].visible: continue
			
			# Any partially obscured light in range
			if partially_obscured_lights[light_index] == true:
				
				return true
		
		
	return false


func any_lights_in_range(a: bool):
	return !a

func all_lights_out_of_range(a: bool):
	return a

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ExitLevel"):
		end_level()
	
	if is_dark_mode:
		
		if is_player_in_light_dark_mode():
			
			player.shrink(shrink_rate)
			
		else:
			
			player.grow(grow_rate)
	
	else:
		
		if is_player_in_light():
			
			player.shrink(shrink_rate)
			
		else:
			
			player.grow(grow_rate)


func _on_no_grow_zone_player_entered(max_player_size: float) -> void:
	player.no_grow = true
	player.max_size = max_player_size


func _on_no_grow_zone_player_exited() -> void:
	player.no_grow = false
	player.max_size = player.max_health


func _on_player_death() -> void:
	
	end_level()


func _on_finish_finished() -> void:
	
	player.disable_movement = true
	$AnimationPlayer.play("slide_transition")
	LevelTracker.complete_level(level_name)


func invert_level():
	print("invert")
	set_dark_mode(!is_dark_mode)


func set_dark_mode(is_dark: bool):
	print("dark")
	is_dark_mode = is_dark
	
	if is_dark:
		
		for light in scene_lights.get_lights():
			light.blend_mode = Light2D.BLEND_MODE_SUB
		
		for light in $LevelLights.get_children():
			light.blend_mode = Light2D.BLEND_MODE_SUB
		
		$BackgroundAudio.pitch_scale = 0.78
	
	else:
		
		for light in scene_lights.get_lights():
			light.blend_mode = Light2D.BLEND_MODE_ADD
		
		for light in $LevelLights.get_children():
			light.blend_mode = Light2D.BLEND_MODE_ADD
		
		$BackgroundAudio.pitch_scale = 0.83
	
	for wall in level_boundary.get_children():
		wall.set_dark(is_dark)
		
	for wall in level_walls.get_children():
		wall.set_dark(is_dark)
	
	$Background/BackgroundColor.set_dark(is_dark)
	player.set_dark(is_dark)


func hide_lights():
	
	for light in scene_lights.get_lights():
		light.visible = false


func end_level():
	
	var level_select = load("res://menus/level_select.tscn")
	get_tree().change_scene_to_packed(level_select)
