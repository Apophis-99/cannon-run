extends Node2D

@export var enemy_spawn_points: Array[Marker2D] = []

func _ready() -> void:
	for point in enemy_spawn_points:
		Game.add_enemy_spawn_location(point.position)
