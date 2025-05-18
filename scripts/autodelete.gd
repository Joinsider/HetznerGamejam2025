extends Node2D

func _ready() -> void:
	$Audio.play()

func _on_delete_timer_timeout() -> void:
	queue_free()
