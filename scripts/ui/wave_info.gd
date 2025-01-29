extends Control

@onready var wave_info: VBoxContainer = $"Screen Padding/Wave Info"
@onready var wave_label: Label = $"Screen Padding/Wave Info/Wave Label"
@onready var wave_progress: ProgressBar = $"Screen Padding/Wave Info/Wave Progress"
@onready var wave_remaining_label: Label = $"Screen Padding/Wave Info/Wave Remaining Label"

@onready var wave_notification_label: Label = $"Screen Padding/Wave Notification Label"

func _ready() -> void:
	Game.wave_started.connect(_on_wave_started)
	Game.wave_ended.connect(_on_wave_ended)

func _physics_process(delta: float) -> void:
	var enemies_remaining := Game.get_wave_enemy_count()
	wave_remaining_label.text = str(enemies_remaining) + " remaining"
	wave_progress.value = 1.0 - Game.get_wave_progress()

func _on_wave_started(wave_num: int) -> void:
	wave_info.hide()
	wave_notification_label.show()
	wave_notification_label.text = "Wave " + str(wave_num) + " started"
	var tween = create_tween()
	tween.tween_property(wave_notification_label, "modulate", Color.TRANSPARENT, 3.0)
	tween.tween_callback(_wave_started_after_tween)

func _on_wave_ended(wave_num: int) -> void:
	wave_info.hide()
	wave_notification_label.show()
	wave_notification_label.text = "Wave " + str(wave_num) + " completed"
	var tween = create_tween()
	tween.tween_property(wave_notification_label, "modulate", Color.TRANSPARENT, 3.0)
	tween.tween_callback(_wave_started_after_tween)

func _wave_started_after_tween():
	wave_notification_label.hide()
	wave_notification_label.modulate = Color.WHITE
	wave_info.show()

func _on_next_wave_pressed() -> void:
	Game.spawn_next_wave()
