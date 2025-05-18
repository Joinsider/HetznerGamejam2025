##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node

enum Attack {
	DDOS,
	OVERVOLTAGE,
	THUNDERSTORM,
	FREEZE,
	FOG,
	CATSFISTS
	
}

enum ConfigName {
	difficulty1,
	difficulty2,
	difficulty3
}

var configs = {
	ConfigName.difficulty1: GameConfig.new(
		"Haste",
		[
			MachineLevel.new(0, 0, 0),
			MachineLevel.new(10, 20, 1000),
			MachineLevel.new(20, 50, 2000),
			MachineLevel.new(50, 100, 4000),
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
			Attack.OVERVOLTAGE:500,
			Attack.THUNDERSTORM:200,
			Attack.FREEZE:50,
			Attack.FOG:50,
			Attack.CATSFISTS:20000
		},
		0.8,
		1.3,
		func(difficulty: int) -> int: return int(pow(difficulty,1.91)),
		50), 
	ConfigName.difficulty2:  GameConfig.new(
		"Easy",
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
			Attack.FOG:50,
			Attack.CATSFISTS:20000
		},
		0.5,
		2,
		func(difficulty: int) -> int: return int(pow(difficulty,1.6)),
		100),
	ConfigName.difficulty3:  GameConfig.new(
		"Fun",
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
			Attack.FOG:50,
			Attack.CATSFISTS:20000
		},
		0.5,
		2,
		func(difficulty: int) -> int: return int(pow(difficulty,1.75)),
		0),

	
}

var config: GameConfig = configs[ConfigName.difficulty1]
