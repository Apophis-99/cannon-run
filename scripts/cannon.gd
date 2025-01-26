extends StaticBody2D

@export var data: CannonData

@onready var aim_line: Line2D = $"Aim Line"
@onready var target_sprite: Sprite2D = $"Target Sprite"
@onready var key_indicator_container: Node2D = $"Key Indicator Container"
@onready var target_hitbox: Hitbox = $"Target Hitbox"
@onready var target_hitbox_collider: CollisionShape2D = $"Target Hitbox/Target Hitbox Collider"

var _player_in_hitbox: bool = false
var _player: CharacterBody2D = null
var _in_cannon: bool = false
var _leaving_cannon: bool = false
var _aim_point: Vector2

func _on_cannon_hitbox_body_entered(body: Node2D) -> void:
	if body.has_meta("is_player"):
		_player_in_hitbox = true
		_player = body
		key_indicator_container.show()
		key_indicator_container.global_rotation = 0

func _on_cannon_hitbox_body_exited(body: Node2D) -> void:
	if _in_cannon or _leaving_cannon:
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
	_handle_fire(delta)

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

func _handle_fire(delta: float):
	if not _in_cannon and not _leaving_cannon:
		return
	if Input.is_action_just_pressed("fire_cannon"):
		_leaving_cannon = true
		_in_cannon = false
		aim_line.hide()
		_player.disable_legs()
		_player.position = to_global(aim_line.points[0])
		_player.show()
		
	if _leaving_cannon:
		_player.position = _player.position.move_toward(to_global(_aim_point), delta * 400)
		if (_player.position - to_global(_aim_point)).length() < 0.1:
			_leaving_cannon = false
		
		if not _leaving_cannon:
			target_hitbox.show()
			target_hitbox.position = _aim_point
			var shape = CircleShape2D.new()
			shape.radius = data.damage_spread
			target_hitbox_collider.shape = shape
			_player.process_mode = Node.PROCESS_MODE_INHERIT
			_player.enable_legs()
			target_sprite.hide()
			_player_in_hitbox = false
			target_hitbox.deal_damage(20.0, Hitbox.Type.Enemy)
			queue_redraw()

func _draw() -> void:
	if _in_cannon or _leaving_cannon:
		draw_circle(_aim_point, data.damage_spread, Color.RED, false, 1, true)
