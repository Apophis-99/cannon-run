extends StaticBody2D

@export var data: CannonData

@onready var aim_line: Line2D = $"Aim Line"
@onready var target_sprite: Sprite2D = $"Target Sprite"
@onready var key_indicator_container: Node2D = $"Key Indicator Container"
@onready var target_hitbox: Hitbox = $"Target Hitbox"

var _player_in_hitbox: bool = false
var _player: CharacterBody2D = null
var _in_cannon: bool = false
var _aim_point: Vector2

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_meta("is_player"):
		_player_in_hitbox = true
		_player = body
		key_indicator_container.show()
		key_indicator_container.global_rotation = 0

func _on_hitbox_body_exited(body: Node2D) -> void:
	if _in_cannon:
		return
	if body.has_meta("is_player"):
		_player_in_hitbox = false
		key_indicator_container.hide()

# If in cannon range and not already in cannon, press "enter_cannon" to set flag to true
# If in cannon rotate cannon according to mouse position, when "fire_cannon" pressed launch player in direction of cannon
func _physics_process(delta: float) -> void:
	if not _player_in_hitbox or not _player:
		return
	_check_enter_cannon()
	_handle_cannon(delta)
	_handle_fire()

func _check_enter_cannon():
	if Input.is_action_just_pressed("enter_cannon") and not _in_cannon:
		_in_cannon = true
		_player.process_mode = Node.PROCESS_MODE_DISABLED
		_player.hide()
		aim_line.show()
		target_sprite.show()
		key_indicator_container.hide()
		target_hitbox.hide()

func _handle_cannon(delta: float):
	if not _in_cannon:
		return
	look_at(get_global_mouse_position())
	var rel_mpos = get_local_mouse_position()
	if (rel_mpos.length() > data.max_range):
		rel_mpos = rel_mpos.normalized() * data.max_range
	if (rel_mpos.length() < data.min_range):
		rel_mpos = rel_mpos.normalized() * data.min_range
	aim_line.points[1] = rel_mpos
	target_sprite.position = rel_mpos
	target_sprite.global_rotation = 0
	_aim_point = rel_mpos
	
	var midpoint = to_global(rel_mpos / 2.0)
	var camera = get_viewport().get_camera_2d()
	camera.position = midpoint
	var zoom = move_toward(camera.zoom.x, 1.5, delta)
	camera.zoom = Vector2(zoom, zoom)
	
	queue_redraw()

func _handle_fire():
	if not _in_cannon:
		return
	if Input.is_action_just_pressed("fire_cannon"):
		_in_cannon = false
		target_hitbox.show()
		target_hitbox.position = _aim_point
		var shape = CircleShape2D.new()
		shape.radius = data.damage_spread
		target_hitbox.collision_shape = shape
		_player.position = to_global(_aim_point)
		_player.process_mode = Node.PROCESS_MODE_INHERIT
		_player.show()
		aim_line.hide()
		target_sprite.hide()

func _draw() -> void:
	if _in_cannon:
		draw_circle(_aim_point, data.damage_spread, Color.RED, false, 1, true)
