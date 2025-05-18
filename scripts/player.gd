##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
class_name Player
extends CharacterBody2D

signal coins_updated(coins: int)
signal collectable_coins_updated(coins: int)
signal machine_upgraded
signal demand_updated(new_demand: int)
signal utilization_updated(utilization: float)
signal attack_started(attack: Gameconstants.Attack)
signal attack_ended(attack: Gameconstants.Attack)

enum AnimationType {
	DEFAULT,
	KNIVE,
	SLEEP
}

const _animations = {
	0: {
		AnimationType.DEFAULT: "duck0",
		AnimationType.KNIVE: "duck0-knive",
		AnimationType.SLEEP: "duck0-sleep"
	},
	1: {
		AnimationType.DEFAULT: "duck1",
		AnimationType.KNIVE: "duck1-knive",
		AnimationType.SLEEP: "duck1-sleep"
	},
}

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
	Gameconstants.Attack.FOG:preload("res://scene/effects/fog.tscn"),
	Gameconstants.Attack.CATSFISTS:preload("res://scene/effects/catsfists.tscn")
}

var killer = false

func set_default_animation() -> void:
	if killer:
		$AnimatedSprite2D.animation = _animations[PlayerIndex][AnimationType.KNIVE]
	else:
		$AnimatedSprite2D.animation = _animations[PlayerIndex][AnimationType.DEFAULT]

func _otherPlayer(player:int) -> int:
	return posmod(player + 1, 2)

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
		$AnimatedSprite2D.animation = _animations[PlayerIndex][AnimationType.SLEEP]
	if type == Gameconstants.Attack.OVERVOLTAGE:
		var suitable_machines = get_machines(1)
		suitable_machines.shuffle()
		print(suitable_machines)
		var affected_machines: int = floor(randf_range(1, suitable_machines.size()))
		print(affected_machines)
		for i in range(affected_machines):
			suitable_machines[i].downgrade()
	if type == Gameconstants.Attack.CATSFISTS:
		Gamestate.players[_otherPlayer(PlayerIndex)].show_message("Kill Them!!")
		Gamestate.players[_otherPlayer(PlayerIndex)].killer = true
		Gamestate.players[_otherPlayer(PlayerIndex)].set_default_animation()
		for child in get_parent().get_children():
			if child.name == "Middle":
				child.free()
			elif child.name == "Sprite2D":
				child.texture = load("res://sprites/background-open.png")
				
		
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

func _ready() -> void:
	set_default_animation()
	Gamestate.players[PlayerIndex] = self
	utilization_updated.connect(check_death_timer)
	
@onready var _last_position_step: Vector2 = position
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_vector(_controlls[PlayerIndex][0], _controlls[PlayerIndex][1], _controlls[PlayerIndex][2], _controlls[PlayerIndex][3])
	velocity = input_direction * 50
	
	if is_in_menu or _frezed:
		$AnimatedSprite2D.pause()
		return
	move_and_slide()
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.pause()
	$AnimatedSprite2D.flip_h = input_direction[0] < 0
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
		set_default_animation()
	utilization_updated.emit(get_utilization())


func _on_demand_progress_timeout() -> void:
	_difficulty += 1
	_demand = Gameconstants.config.demand.call(_difficulty)
	demand_updated.emit(_demand)
	utilization_updated.emit(get_utilization())


func _on_death_timer_timeout() -> void:
	Gamestate.switch_to_gameover(PlayerIndex != 0)

func zZz() -> void:
	$zZz.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Gamestate.players[_otherPlayer(PlayerIndex)] and killer:
		Gamestate.players[_otherPlayer(PlayerIndex)].zZz()
		var timer := Timer.new()
		timer.wait_time = 3.0
		timer.one_shot = true
		timer.autostart = true
		add_child(timer)

		# Connect timeout signal to a lambda function
		timer.timeout.connect(func(): 
			Gamestate.switch_to_gameover(_otherPlayer(PlayerIndex))

		)
		
		
