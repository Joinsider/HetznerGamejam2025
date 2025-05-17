extends Label

@export var type : Gameconstants.Attack
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = text + " ("+ str(Gameconstants.config.attack_costs[type]) +")"
