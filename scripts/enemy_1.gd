extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar


func _on_health_component_damage_taken(amount: float) -> void:
	progress_bar.value -= amount


func _on_health_component_died() -> void:
	queue_free()
