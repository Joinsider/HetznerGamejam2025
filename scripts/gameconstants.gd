extends Node

enum Attack {
	DDOS,
	OVERVOLTAGE,
	THUNDERSTORM,
	FREEZE,
	FOG
}

var machine_levels: Array[MachineLevel] = [
	MachineLevel.new(0, 0, 0),
	MachineLevel.new(10, 20, 1000),
	MachineLevel.new(20, 50, 2000),
	MachineLevel.new(50, 100, 5000),
	MachineLevel.new(100, 300, 10000),
	MachineLevel.new(300, 1000, 30000)
]

var AttackCosts = {
	Attack.DDOS:200,
	Attack.OVERVOLTAGE:300,
	Attack.THUNDERSTORM:400,
	Attack.FREEZE:50,
	Attack.FOG:50
}

const thunderstorm_multiplier: float = 0.5
const ddos_multiplier: float = 2

var demand = func(difficulty: int) -> int:
	return int(pow(difficulty,1.8))
