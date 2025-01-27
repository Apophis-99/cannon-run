class_name CharacterControllerComponent
extends Node

@export var movement_component: MovementComponent
@export var animation_player: AnimationPlayer

@export_category("Inputs")
@export var move_left_input_name: StringName
@export var move_right_input_name: StringName
@export var move_up_input_name: StringName
@export var move_down_input_name: StringName
@export var dash_input_name: StringName

@export_category("Animations")
@export var run_animation_name: StringName

func _physics_process(_delta: float) -> void:
	if not movement_component:
		return
	
	if Input.is_action_just_pressed(dash_input_name):
		movement_component.dash()
	
	var horiz := Input.get_axis(move_left_input_name, move_right_input_name)
	var vert := Input.get_axis(move_up_input_name, move_down_input_name)
	movement_component.move(horiz, vert)
	
	if not animation_player:
		return
	if horiz == 0 and vert == 0:
		animation_player.stop()
	else:
		animation_player.play(run_animation_name)
