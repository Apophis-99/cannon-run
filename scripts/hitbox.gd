@tool
class_name Hitbox
extends Area2D

@export var collision_shape: Shape2D : 
	set(shape):
		collider.shape = shape

@onready var collider: CollisionShape2D = $Collider

func _ready() -> void:
	collider.shape = collision_shape
