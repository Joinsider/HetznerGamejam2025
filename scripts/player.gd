extends CharacterBody2D


@export var SPEED = 150.0
@export var Player = 0


var controlls = [
 	["player0_left", "player0_right", "player0_up", "player0_down"],
	["player1_left", "player1_right", "player1_up", "player1_down"]
]
var sprite = [
	preload("res://sprites/Duck0.png"),
	preload("res://sprites/Duck1.png")
]

func _ready() -> void:
	$Sprite2D.texture = sprite[Player]


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis(controlls[Player][0], controlls[Player][1])
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y := Input.get_axis(controlls[Player][2], controlls[Player][3])
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
