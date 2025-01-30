extends Node2D

@export var enemy_spawn_points: Array[Marker2D] = []

func _ready() -> void:
	for point in enemy_spawn_points:
		Game.add_enemy_spawn_location(point.position)
	call_deferred("_start_game")

func _start_game():
	await get_tree().physics_frame
	Game.start_game()
