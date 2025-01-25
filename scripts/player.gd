extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	camera.position = position
	var zoom = move_toward(camera.zoom.x, 2.0, delta)
	camera.zoom = Vector2(zoom, zoom)
