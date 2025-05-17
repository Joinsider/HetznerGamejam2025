extends Node2D

@export var Player: int = 0

const _sprite = [
	preload("res://sprites/1-coin.png"),
	preload("res://sprites/2-coins.png"),
	preload("res://sprites/3-coins.png"),
	preload("res://sprites/coins_pile.png"),
]

const _money_limits = [
	100, 400, 1000, 100000000
]

func _ready() -> void:
	Gamestate.players[Player].collectable_coins_updated.connect(_on_collectable_coins_updated)
	_on_collectable_coins_updated(0)

func _on_collectable_coins_updated(coins: int):
	$Money.text = str(coins) + " G"
	for i in range(_money_limits.size()):
		if coins > _money_limits[i]:
			continue
		$Sprite2D.texture = _sprite[i]
		break

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body == Gamestate.players[Player]):
		return
	Gamestate.players[Player].collect_coins()
