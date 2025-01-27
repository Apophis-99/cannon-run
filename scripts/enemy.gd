extends CharacterBody2D

@export var target_player: bool
@export var target_cannon: bool
@export var attack_distance: float
@export var health_bar: ProgressBar
@export var nav: NavigationAgent2D

func _ready() -> void:
	set_physics_process(false)
	call_deferred("physics_deffered")

func physics_deffered() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var target = position
	if target_player:
		target = get_player_position()
	elif target_cannon:
		target = get_closest_cannon_position()
	nav.target_position = target
	
	var direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var dist = position.distance_to(target)
	if dist <= attack_distance:
		return
	
	velocity = velocity.lerp(direction * 100, 7 * delta)
	move_and_slide()

func _on_health_component_damage_taken(amount: float) -> void:
	health_bar.show()
	health_bar.value -= amount
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): modulate = Color.WHITE)

func _on_health_component_died() -> void:
	health_bar.hide()
	
	modulate = Color.RED
	create_tween().tween_property(self, "scale", Vector2(0.1, 0.1), 0.6).set_trans(Tween.TRANS_LINEAR)
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 90.0, 0.6).set_trans(Tween.TRANS_LINEAR).as_relative()
	tween.tween_callback(func(): queue_free())

func get_player_position() -> Vector2:
	var player_nodes := get_tree().get_nodes_in_group("player")
	for player in player_nodes:
		return player.position
	return Vector2(0.0, 0.0)

func get_closest_cannon_position() -> Vector2:
	var cannon_nodes := get_tree().get_nodes_in_group("cannons")
	var closest_dist := 100000.0
	var closest_position := Vector2(0.0, 0.0)
	for cannon in cannon_nodes:
		var dist = cannon.position.distance_to(position)
		if dist < closest_dist:
			closest_dist = dist
			closest_position = cannon.position
	return closest_position
