##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node

enum Attack {
	DDOS,
	OVERVOLTAGE,
	THUNDERSTORM,
	FREEZE,
	FOG
}

enum ConfigName {
	difficulty1,
	difficulty2
}

var configs = {
	ConfigName.difficulty1: GameConfig.new(
		"Dif 1",
		[
			MachineLevel.new(0, 0, 0),
			MachineLevel.new(10, 20, 1000),
			MachineLevel.new(20, 50, 2000),
			MachineLevel.new(50, 100, 5000),
			MachineLevel.new(100, 300, 10000),
			MachineLevel.new(300, 1000, 30000)
		],
		[
			99, # Maximum for one coin
			399, # Maximum for two coins
			999, # Maximum for three coins
			100000000 # Maximum for coin pile (Infinite)
		],
		{
			Attack.DDOS:200,
			Attack.OVERVOLTAGE:300,
			Attack.THUNDERSTORM:400,
			Attack.FREEZE:50,
			Attack.FOG:50
		},
		0.5,
		2,
		func(difficulty: int) -> int: return int(pow(difficulty,1.8)),
		500),
	ConfigName.difficulty2:  GameConfig.new(
		"Dif 2",
		[
			MachineLevel.new(0, 0, 0),
			MachineLevel.new(10, 20, 1000),
			MachineLevel.new(20, 50, 2000),
			MachineLevel.new(50, 100, 5000),
			MachineLevel.new(100, 300, 10000),
			MachineLevel.new(300, 1000, 30000)
		],
		[
			99, # Maximum for one coin
			399, # Maximum for two coins
			999, # Maximum for three coins
			100000000 # Maximum for coin pile (Infinite)
		],
		{
			Attack.DDOS:200,
			Attack.OVERVOLTAGE:300,
			Attack.THUNDERSTORM:400,
			Attack.FREEZE:50,
			Attack.FOG:50
		},
		0.5,
		2,
		func(difficulty: int) -> int: return int(pow(difficulty,2)),
		50),
	
}

var config: GameConfig = configs[ConfigName.difficulty1]
