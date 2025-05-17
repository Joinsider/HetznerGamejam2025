class_name Player
extends CharacterBody2D

signal coins_updated(coins: int)
signal collectable_coins_updated(coins: int)
signal machine_upgraded
signal demand_updated(new_demand: int)
signal attack_started(attack: Gameconstants.Attack)
signal attack_ended(attack: Gameconstants.Attack)

@export var SPEED = 50.0
@export var PlayerIndex = 0
@export var Test :PackedScene

var is_in_menu: bool = false
var _collectable_coins: int = 0
var _coins: int = 50
var _machines: Array[Machine] = []
var _frezed

var _demand: int = 100 #Requests Per Second

var activeAttacks = {}

var attackScene = {
	Gameconstants.Attack.DDOS:preload("res://scene/effects/ddos.tscn"),
	Gameconstants.Attack.OVERVOLTAGE:preload("res://scene/effects/overvoltage.tscn"),
	Gameconstants.Attack.THUNDERSTORM:preload("res://scene/effects/thunderstorm.tscn"),
	Gameconstants.Attack.FREEZE:preload("res://scene/effects/freeze.tscn"),
	Gameconstants.Attack.FOG:preload("res://scene/effects/fog.tscn")
}

func get_income() -> int:
	var income: int = 0
	for machine in _machines:
		income += Gameconstants.machine_levels[machine.level].outcome
	return income
func get_performance() -> int:
	var performance: int = 0
	for machine in _machines:
		performance += Gameconstants.machine_levels[machine.level].performance
	if Gameconstants.Attack.THUNDERSTORM in activeAttacks:
		return floor(performance / 2)
	return performance
func get_demand() -> int:
	if Gameconstants.Attack.DDOS in activeAttacks:
		return _demand * 2
	return _demand
	
func attack(type: Gameconstants.Attack) -> void:
	print(str(PlayerIndex)+" got atacked with "+str(type))
	if type in activeAttacks:
		activeAttacks[type].queue_free()
	activeAttacks[type] = attackScene[type].instantiate()
	if PlayerIndex == 1:
		activeAttacks[type].position.x = 256
	get_parent().add_child(activeAttacks[type])
	activeAttacks[type].tree_exiting.connect(func():
		_on_attack_finish(type)
	)
	if type == Gameconstants.Attack.FREEZE:
		_frezed = true
		$Sprite2D.texture = _sprite[PlayerIndex+2]
	attack_started.emit(type)
	

func add_machine(machine: Machine) -> void:
	_machines.append(machine)
	machine.on_upgrade.connect(_on_machine_upgrade)
	
func _on_machine_upgrade(new_level: int) -> void:
	machine_upgraded.emit()
	

func has_coins(amount: int) -> bool:
	return _coins >= amount
	
func remove_coins(amount: int) -> bool:
	if (!has_coins(amount)):
		return false
	_coins -= amount
	coins_updated.emit(_coins)
	return true
	
func add_coins(amount: int) -> void:
	_coins += amount
	coins_updated.emit(_coins)
	
func add_collectable_coins(amount: int) -> void:
	_collectable_coins += amount
	collectable_coins_updated.emit(_collectable_coins)
	
func collect_coins() -> void:
	add_coins(_collectable_coins)
	_collectable_coins = 0
	collectable_coins_updated.emit(_collectable_coins)

func show_message(message: String) -> void:
	$CenterContainer/Notification.text = message
	$NotificationTimer.start()

var _controlls = [
 	["player0_left", "player0_right", "player0_up", "player0_down"],
	["player1_left", "player1_right", "player1_up", "player1_down"]
]
var _sprite = [
	preload("res://sprites/Duck0.png"),
	preload("res://sprites/Duck1.png"),
	preload("res://sprites/Duck0-Sleeping.png"),
	preload("res://sprites/Duck1-Sleeping.png")
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
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if is_in_menu or _frezed:
		return
	move_and_slide()
	$Sprite2D.flip_h = direction_x < 0


func _on_notification_timer_timeout() -> void:
	$CenterContainer/Notification.text = ""

func _on_attack_finish(type: Gameconstants.Attack) -> void:
	activeAttacks.erase(type)
	attack_ended.emit(type)
	if type == Gameconstants.Attack.FREEZE:
		_frezed = false
		$Sprite2D.texture = _sprite[PlayerIndex]
