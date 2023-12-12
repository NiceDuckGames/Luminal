@tool
extends StaticBody2D


@export var size: Vector2:
	set = set_size

@export var occluder_margin: float = 10.0


func set_size(value: Vector2):
	
	size = value
	
	if !is_node_ready(): return
	
	$CollisionShape2D.shape.size = value
	$ColorRect.size = value
	$ColorRect.anchors_preset = Control.PRESET_CENTER
	
	var margined_value: Vector2 = Vector2(clamp(value.x - 10, 0, 99999999), clamp(value.y - 10, 0, 9999999))
	
	var tl: Vector2 = Vector2(-(margined_value.x / 2.0), -(margined_value.y / 2.0))
	var tr: Vector2 = Vector2((margined_value.x / 2.0), -(margined_value.y / 2.0))
	var bl: Vector2 = Vector2(-(margined_value.x / 2.0), (margined_value.y / 2.0))
	var br: Vector2 = Vector2((margined_value.x / 2.0), (margined_value.y / 2.0))
	
	var rect_points: PackedVector2Array = [tl, tr, br, bl]
	
	$LightOccluder2D.occluder = OccluderPolygon2D.new()
	$LightOccluder2D.occluder.set_polygon(rect_points)


func _ready() -> void:
	set_size(size)
