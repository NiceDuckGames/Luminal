extends CharacterBody2D

const max_health: float = 64.0
var health: float = 64.0

const pinch_detection_distance: float = 5.0

const SPEED = 400.0
const RUN_SCALE = 1.5
const DIRECTION_SMOOTHING = 20.0

var last_direction: Vector2 = Vector2()
var no_grow: bool = false
var max_size: float = 64.0
var disable_movement: bool = false

signal death


func _ready() -> void:
	
	self.connect("death", get_tree().current_scene._on_player_death)
	
	self.visible = true


func _physics_process(delta: float) -> void:
	
	if disable_movement: 
		velocity.move_toward(Vector2.ZERO, DIRECTION_SMOOTHING)
		return
	
	var input_y: float = Input.get_axis("Up", "Down")
	var input_x: float = Input.get_axis("Left", "Right")
	
	var input_vec: Vector2 = Vector2(input_x, input_y)
	
	velocity = velocity.move_toward(input_vec * SPEED, DIRECTION_SMOOTHING)
	
	if velocity.length() != 0.0:
		last_direction = velocity.normalized()
	
	move_and_slide()
	
	$GPUParticles2D.process_material.scale_curve.curve["point_0/position"] = Vector2(0.0, (health / max_health) * 1.75)
	$GPUParticles2D.process_material.emission_sphere_radius = health / 2.0


func set_dark(is_dark: bool):
	
	if is_dark:
		
		$Sprite2D.modulate = Color.BLACK
		$GPUParticles2D.modulate = Color.BLACK
	
	else:
		
		$Sprite2D.modulate = Color.WHITE
		$GPUParticles2D.modulate = Color.WHITE


func shrink(damage: float) -> void:
	
	if disable_movement: return
	
	if health <= 0:
		disable_movement = true
		emit_signal("death")
		return
	
	health -= damage
	
	self.scale = Vector2(health / max_health, health / max_health)


func grow(heal: float) -> void:
	
	if health >= max_health || !can_grow(heal) || disable_movement:
		return
	
	health += heal
	
	self.scale = Vector2(health / max_health, health / max_health)


func cast_to_light(l_pos: Vector2, r_pos: Vector2, to_pos: Vector2) -> bool:
	
	$RayCastL.global_position = l_pos
	$RayCastL.target_position = $RayCastL.to_local(to_pos)
	
	$RayCastR.global_position = r_pos
	$RayCastR.target_position = $RayCastR.to_local(to_pos)
	
	if !$RayCastL.get_collider() || !$RayCastR.get_collider():
		return true
	
	return false


func can_grow(heal: float) -> bool:
	
	if !no_grow: return true
	
	if health + heal >= max_size / 2.0:
		return false
	return true


func is_running() -> bool:
	
	if Input.is_action_pressed("Run"):
		return true
	else:
		return false
