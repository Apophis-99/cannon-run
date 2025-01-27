class_name MovementComponent
extends Node

@export var character_body_2d: CharacterBody2D
@export var move_speed: float
@export var dash_speed: float
@export var dash_distance: float

var in_dash: bool

var _movement_vector: Vector2
var _movement_vector_changed: bool
var _velocity: Vector2
var _dash_start_pos: Vector2

func move(horiz: float, vert: float):
	if in_dash:
		return
	_movement_vector = Vector2(horiz, vert)
	_movement_vector_changed = true

func stop():
	if in_dash:
		return
	_movement_vector = Vector2(0, 0)
	_movement_vector_changed = true

func dash():
	if _movement_vector.length() < 0.1:
		return
	in_dash = true
	_dash_start_pos = character_body_2d.position

func _physics_process(_delta: float) -> void:
	if not character_body_2d:
		return
	
	if in_dash:
		if character_body_2d.get_slide_collision_count() > 0:
			in_dash = false
			stop()
		var dist = (character_body_2d.position - _dash_start_pos).length()
		if dist >= dash_distance:
			in_dash = false
			stop()
		else:
			var unit_vec = _movement_vector.normalized()
			_velocity = unit_vec * dash_speed
	
	if _movement_vector_changed:
		var unit_vec = _movement_vector.normalized()
		_velocity = unit_vec * move_speed
		_movement_vector_changed = false
	
	character_body_2d.velocity = _velocity
	character_body_2d.move_and_slide()
