extends Node

var machine_levels: Array[MachineLevel] = [
	MachineLevel.new(0, 0, 0),
	MachineLevel.new(10, 20, 1000),
	MachineLevel.new(20, 50, 2000),
	MachineLevel.new(50, 100, 5000),
	MachineLevel.new(100, 300, 10000),
	MachineLevel.new(300, 1000, 30000)
]

enum Attack {
	DDOS,
	OVERVOLTAGE,
	THUNDERSTORM,
	FREEZE,
	FOG
}

var AttackCosts = {
	Attack.DDOS:200,
	Attack.OVERVOLTAGE:300,
	Attack.THUNDERSTORM:400,
	Attack.FREEZE:50,
	Attack.FOG:50
}
