class_name Player
extends CharacterBody2D

signal coins_updated(coins: int)
signal collectable_coins_updated(coins: int)
signal machine_upgraded
signal demand_updated(new_demand: int)
signal utilization_updated(utilization: float)
signal attack_started(attack: Gameconstants.Attack)
signal attack_ended(attack: Gameconstants.Attack)

@export var SPEED = 50.0
@export var PlayerIndex = 0
@export var Test :PackedScene

var is_in_menu: bool = false
var _collectable_coins: int = 0
var _coins: int = Gameconstants.config.startMoney
var _machines: Array[Machine] = []
var _frezed

var _demand: int = 0 #Requests Per Second
var _difficulty: int = 0

var activeAttacks = {}

var attackScene = {
	Gameconstants.Attack.DDOS:preload("res://scene/effects/ddos.tscn"),
	Gameconstants.Attack.OVERVOLTAGE:preload("res://scene/effects/overvoltage.tscn"),
	Gameconstants.Attack.THUNDERSTORM:preload("res://scene/effects/thunderstorm.tscn"),
	Gameconstants.Attack.FREEZE:preload("res://scene/effects/freeze.tscn"),
	Gameconstants.Attack.FOG:preload("res://scene/effects/fog.tscn")
}

func check_death_timer(utilization: float) -> void:
	if utilization >= 1:
		if $DeathTimer.is_stopped():
			$DeathTimer.start()
	else:
		$DeathTimer.stop()

func get_income() -> int:
	var income: int = 0
	for machine in _machines:
		income += Gameconstants.config.machine_levels[machine.level].outcome
	return income
func get_performance() -> int:
	var performance: int = 0
	for machine in _machines:
		performance += Gameconstants.config.machine_levels[machine.level].performance
	if Gameconstants.Attack.THUNDERSTORM in activeAttacks:
		return floor(performance * Gameconstants.config.thunderstorm_multiplier)
	return performance
func get_demand() -> int:
	if Gameconstants.Attack.DDOS in activeAttacks:
		return _demand * Gameconstants.config.ddos_multiplier
	return _demand
func get_utilization() -> float:
	var demand = get_demand()
	var performance = get_performance()
	var utilization = float(demand)/performance
	utilization = min(utilization, 1)
	return utilization
func get_machines(min_level: int) -> Array[Machine]:
	return _machines.filter(func(m):
		return m.level >= min_level
	)
	
func attack(type: Gameconstants.Attack) -> void:
	print(str(PlayerIndex)+" got atacked with "+str(type))
	
	if type in activeAttacks:
		activeAttacks[type].free()
	activeAttacks[type] = attackScene[type].instantiate()
	activeAttacks[type].z_index = 1
	if PlayerIndex == 1:
		activeAttacks[type].position.x = 512
		activeAttacks[type].scale.x = -1
	get_parent().add_child(activeAttacks[type])
	activeAttacks[type].tree_exiting.connect(func():
		_on_attack_finish(type)
	)
	if type == Gameconstants.Attack.FREEZE:
		_frezed = true
		$Sprite2D.texture = _sprite[PlayerIndex+2]
	if type == Gameconstants.Attack.OVERVOLTAGE:
		var suitable_machines = get_machines(1)
		suitable_machines.shuffle()
		print(suitable_machines)
		var affected_machines: int = floor(randf_range(1, suitable_machines.size()))
		print(affected_machines)
		for i in range(affected_machines):
			suitable_machines[i].downgrade()
	attack_started.emit(type)
	utilization_updated.emit(get_utilization())
	

func add_machine(machine: Machine) -> void:
	_machines.append(machine)
	machine.on_upgrade.connect(_on_machine_upgrade)
	
func _on_machine_upgrade(new_level: int) -> void:
	machine_upgraded.emit()
	utilization_updated.emit(get_utilization())
	

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
	utilization_updated.connect(check_death_timer)
	
var _last_position_step: Vector2 = Vector2(0, 0)
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_vector(_controlls[PlayerIndex][0], _controlls[PlayerIndex][1], _controlls[PlayerIndex][2], _controlls[PlayerIndex][3])
	velocity = input_direction * 50
	
	if is_in_menu or _frezed:
		return
	move_and_slide()
	$Sprite2D.flip_h = input_direction[0] < 0
	if (position - _last_position_step).length() > 20:
		$FootSteps.play()
		_last_position_step = position


func _on_notification_timer_timeout() -> void:
	$CenterContainer/Notification.text = ""

func _on_attack_finish(type: Gameconstants.Attack) -> void:
	activeAttacks.erase(type)
	attack_ended.emit(type)
	if type == Gameconstants.Attack.FREEZE:
		_frezed = false
		$Sprite2D.texture = _sprite[PlayerIndex]
	utilization_updated.emit(get_utilization())


func _on_demand_progress_timeout() -> void:
	_difficulty += 1
	_demand = Gameconstants.config.demand.call(_difficulty)
	demand_updated.emit(_demand)
	utilization_updated.emit(get_utilization())


func _on_death_timer_timeout() -> void:
	Gamestate.switch_to_gameover(PlayerIndex != 0)
