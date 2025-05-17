extends Node2D

@export var Player: int = 0

const SIZE = 180

var desired_percentage: float = 0
var current_percentage: float = 0

func _ready() -> void:
	_move_indicator(0)
	Gamestate.players[Player].demand_updated.connect(_on_demand_updated)
	Gamestate.players[Player].machine_upgraded.connect(_on_machine_upgraded)
	Gamestate.players[Player].attack_started.connect(_on_machine_upgraded)
	_update()

func _move_indicator(percentage: float):
	var delta = (percentage - 0.5) * SIZE
	$Indicator.position = Vector2(delta, 0)

func _on_demand_updated(new_demand: int):
	_update()
	
func _on_attack_started(attack: Gameconstants.Attack):
	_update()
	
func _on_machine_upgraded():
	_update()
	
func _update():
	var demand = Gamestate.players[Player].get_demand()
	var performance = Gamestate.players[Player].get_performance()
	desired_percentage = float(demand)/performance
	desired_percentage = min(desired_percentage, 1)
	$Percentage.text = str(round(desired_percentage*100)) + " %"
	$Demand.text = str(demand) + " Req./s"
	$Performance.text = str(performance) + " Req./s"
	
func _physics_process(delta: float) -> void:
	var step: float = (desired_percentage - current_percentage)*5*delta
	current_percentage += step
	_move_indicator(current_percentage)
	
	
