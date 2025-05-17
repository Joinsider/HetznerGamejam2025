extends Node2D

@export var Player: int = 0

func _ready() -> void:
	Gamestate.players[Player].utilization_updated.connect(update)
	if Player == 1:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play()
	$Audio.play()
	
func update(utilization: float) -> void:
	visible = utilization >= 1 
