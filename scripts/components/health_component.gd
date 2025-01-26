class_name HealthComponent
extends Node

@export var hitbox: Hitbox

@export var health: float

signal damage_taken(amount: float)
signal died

func _ready() -> void:
	if hitbox:
		hitbox.damage_taken.connect(hitbox_damage_taken)

func hitbox_damage_taken(amount: float):
	health -= amount
	damage_taken.emit(amount)
	if health <= 0:
		died.emit()
		health = 0
