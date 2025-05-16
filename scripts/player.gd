class_name Player
extends CharacterBody2D


@export var SPEED = 50.0
@export var PlayerIndex = 0

var _coins: int = 50;

func has_coins(amount: int) -> bool:
	return _coins >= amount
	
func remove_coins(amount: int) -> bool:
	if (!has_coins(amount)):
		return false
	_coins -= amount
	return true
	
func add_coins(amount: int) -> void:
	_coins += amount

var _controlls = [
 	["player0_left", "player0_right", "player0_up", "player0_down"],
	["player1_left", "player1_right", "player1_up", "player1_down"]
]
var _sprite = [
	preload("res://sprites/Duck0.png"),
	preload("res://sprites/Duck1.png")
]

func _ready() -> void:
	$Sprite2D.texture = _sprite[PlayerIndex]
	Gamestate.players[PlayerIndex] = self

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis(_controlls[PlayerIndex][0], _controlls[PlayerIndex][1])
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y := Input.get_axis(_controlls[PlayerIndex][2], _controlls[PlayerIndex][3])
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
