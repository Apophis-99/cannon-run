@tool
class_name Hitbox
extends Area2D

enum Type {
	General,
	Player,
	Enemy,
	Cannon
}

signal damage_dealt(damage: float)
signal damage_taken(damage: float)
signal stunned(hitbox: Hitbox)

@export var type: Type

var _should_deal_damage: bool
var _deal_damage_amount: float
var _wait_time: float
var _target_type: Type

func _physics_process(delta: float) -> void:
	_wait_time += delta
	if _should_deal_damage and _wait_time > 0.1:
		_deal_damage(_deal_damage_amount, _target_type)
		_should_deal_damage = false
		_deal_damage_amount = 0.0
		_wait_time = 0.0

func deal_damage(damage: float, hitbox_type: Type):
	_should_deal_damage = true
	_deal_damage_amount = damage
	_target_type = hitbox_type

func _deal_damage(damage: float, hitbox_type: Type):
	var count := 0
	for hitbox in get_overlapping_areas():
		if hitbox is Hitbox:
			if hitbox.type == hitbox_type:
				hitbox.take_damage(damage)
				count += 1
	damage_dealt.emit(count * damage)
	_should_deal_damage = false

func take_damage(damage: float):
	damage_taken.emit(damage)

func stun(type: Type):
	for hitbox in get_overlapping_areas():
		if hitbox is Hitbox:
			if hitbox.type == type:
				hitbox.stunned.emit(self)
