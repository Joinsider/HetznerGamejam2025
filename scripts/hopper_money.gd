extends Node2D

@export var Player: int = 0

func _ready() -> void:
	Gamestate.players[Player].collectable_coins_updated.connect(_on_collectable_coins_updated)
	_on_collectable_coins_updated(0)

func _on_collectable_coins_updated(coins: int):
	$Money.text = str(coins) + " G"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body == Gamestate.players[Player]):
		return
	Gamestate.players[Player].collect_coins()
