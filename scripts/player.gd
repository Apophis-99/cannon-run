extends CharacterBody2D

@onready var health_bar: ProgressBar = $"Health Bar"

@onready var left_leg: Sprite2D = $"Left Leg"
@onready var right_leg: Sprite2D = $"Right Leg"
@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	Game.game_started.connect(_start_game)
	Game.wave_ended.connect(_wave_ended)

func _physics_process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	camera.position = position
	var zoom = move_toward(camera.zoom.x, 2.0, delta)
	camera.zoom = Vector2(zoom, zoom)

func enable_legs():
	left_leg.show()
	right_leg.show()

func disable_legs():
	left_leg.hide()
	right_leg.hide()


func _on_health_component_damage_taken(amount: float) -> void:
	health_bar.value -= amount

func _on_health_component_died() -> void:
	Game.player_died.emit()

func _start_game() -> void:
	for i in range(0, 180):
		await get_tree().physics_frame
	Game.spawn_next_wave()

func _wave_ended(wave_num: int) -> void:
	_start_game()
