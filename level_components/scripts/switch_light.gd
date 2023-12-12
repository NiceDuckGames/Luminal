@tool
extends PointLight2D


var player: CharacterBody2D

@export var compare_vector: Vector2 = Vector2.UP

@export var switch: Area2D

var l_ray: RayCast2D = RayCast2D.new()
var r_ray: RayCast2D = RayCast2D.new()

@onready var spotlight_bound_l: RayCast2D = $SpotlightBounds
@onready var spotlight_bound_r: RayCast2D = $SpotlightBounds2

@export var is_spotlight: bool = false:
	set = set_is_spotlight

@export var spotlight_bound_l_angle: float = 90.0:
	set = set_spotlight_bound_l_angle

@export var spotlight_bound_r_angle: float = 90.0:
	set = set_spotlight_bound_r_angle


func _ready() -> void:
	
	l_ray.name = "L"
	l_ray.top_level = true
	
	r_ray.name = "R"
	r_ray.top_level = true
	
	self.add_child(l_ray)
	self.add_child(r_ray)
	
	set_is_spotlight(is_spotlight)
	set_spotlight_bound_l_angle(spotlight_bound_l_angle)
	set_spotlight_bound_r_angle(spotlight_bound_r_angle)
	
	if Engine.is_editor_hint(): return
	if !switch: return
	
	switch.connect("pressed", self._on_switch_pressed)
	switch.connect("pressed", get_parent()._on_light_switch_pressed)


func set_is_spotlight(value: bool):
	
	is_spotlight = value
	
	if !is_node_ready(): return
	
	if is_spotlight:
		spotlight_bound_l.enabled = true
		spotlight_bound_r.enabled = true
	else:
		spotlight_bound_l.enabled = false
		spotlight_bound_r.enabled = false


func set_spotlight_bound_l_angle(value: float):
	
	spotlight_bound_l_angle = value
	
	if !is_node_ready(): return
	
	var spotlight_bound_l_target: Vector2 = Vector2.LEFT * ((texture.get_size() / 2.0) * texture_scale)
	var spotlight_bound_rotated: Vector2 = spotlight_bound_l_target.rotated(-spotlight_bound_l_angle)
	
	spotlight_bound_l.target_position = spotlight_bound_rotated


func set_spotlight_bound_r_angle(value: float):
	
	spotlight_bound_r_angle = value
	
	if !is_node_ready(): return
	
	var spotlight_bound_r_target: Vector2 = Vector2.LEFT * ((texture.get_size() / 2.0) * texture_scale)
	var spotlight_bound_rotated: Vector2 = spotlight_bound_r_target.rotated(-spotlight_bound_r_angle)
	
	spotlight_bound_r.target_position = spotlight_bound_rotated


func is_player_on_light() -> bool:
	
	if self.global_position.distance_to(player.global_position) < player.health:
		return true
	return false


func is_player_in_spotlight() -> bool:
	
	var l_ray_angle_to_up: float = l_ray.target_position.angle_to(compare_vector) + deg_to_rad(180)
	var r_ray_angle_to_up: float = r_ray.target_position.angle_to(compare_vector)  + deg_to_rad(180)
	
	var l_bound_angle_to_up: float = spotlight_bound_l.target_position.rotated(rotation).angle_to(compare_vector) + deg_to_rad(180)
	var r_bound_angle_to_up: float = spotlight_bound_r.target_position.rotated(rotation).angle_to(compare_vector) + deg_to_rad(180)
	
	if l_ray_angle_to_up > r_bound_angle_to_up && l_ray_angle_to_up < l_bound_angle_to_up:
		return true
	elif r_ray_angle_to_up > r_bound_angle_to_up && r_ray_angle_to_up < l_bound_angle_to_up:
		return true
	elif spotlight_bound_l.get_collider() == player && spotlight_bound_r.get_collider() == player:
		return true
	
	return false


func _on_switch_pressed():
	
	self.queue_free()
