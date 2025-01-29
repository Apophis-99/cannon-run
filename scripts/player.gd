extends CharacterBody2D

@onready var health_bar: ProgressBar = $"Health Bar"

@onready var left_leg: Sprite2D = $"Left Leg"
@onready var right_leg: Sprite2D = $"Right Leg"
@onready var hitbox: Hitbox = $Hitbox

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
	pass
