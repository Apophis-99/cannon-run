extends Node

const SQUIGGLE = preload("res://scenes/enemies/squiggle.tscn")

enum WaveDifficulty {
	Basic,
	Tough,
	Challenging
}

## ------------------------------------ Private Variables ------------------------------------ ##

var _current_wave: int
var _max_waves: int = 10
var _enemy_spawn_locations: Array[Vector2] = []


## ------------------------------------ Signals ------------------------------------ ##

signal game_started
signal wave_started(wave: int)
signal wave_ended(wave: int)


## ------------------------------------ Public Functions ------------------------------------ ##

func start_game():
	game_started.emit()

func end_game():
	pass

func spawn_next_wave():
	_current_wave += 1
	var count := 5 * _current_wave
	var difficulty: float = float(_max_waves) / float(_max_waves - _current_wave)
	_spawn_wave(count, int(difficulty))
	wave_started.emit(_current_wave)

func add_enemy_spawn_location(location: Vector2):
	_enemy_spawn_locations.push_back(location)

func get_wave_enemy_count() -> int:
	return get_tree().get_node_count_in_group("enemies")

func get_wave_progress() -> float:
	return 1.0 - get_wave_enemy_count() / (5.0 * _current_wave)


## ------------------------------------ Engine Callbacks ------------------------------------ ##

func _physics_process(_delta: float) -> void:
	_check_wave_over()


## ------------------------------------ Private Functions ------------------------------------ ##

func _check_wave_over():
	var enemy_count := get_wave_enemy_count()
	if enemy_count == 0:
		wave_ended.emit(_current_wave)

func _spawn_wave(count: int, difficulty: WaveDifficulty):
	for i in range(0, count):
		var enemy = SQUIGGLE.instantiate()
		enemy.add_to_group("enemies")
		var loc = Vector2(0.0, 0.0)
		if len(_enemy_spawn_locations) > 0:
			loc = _enemy_spawn_locations[randi() % len(_enemy_spawn_locations)]
		enemy.position = loc
		enemy.target_player = true
		get_tree().current_scene.add_child(enemy)
