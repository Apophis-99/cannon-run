class_name MovementComponent
extends Node

@export var character_body_2d: CharacterBody2D
@export var move_speed: float

var _movement_vector: Vector2
var _movement_vector_changed: bool
var _velocity: Vector2

func move(horiz: float, vert: float):
	_movement_vector = Vector2(horiz, vert)
	_movement_vector_changed = true

func stop():
	_movement_vector = Vector2(0, 0)
	_movement_vector_changed = true

func _physics_process(delta: float) -> void:
	if not character_body_2d:
		return
	
	if _movement_vector_changed:
		var unit_vec = _movement_vector.normalized()
		_velocity = unit_vec * move_speed
		_movement_vector_changed = false
	
	character_body_2d.velocity = _velocity
	character_body_2d.move_and_slide()
