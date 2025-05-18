/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Sprite2D

var sprites = [
	"res://sprites/Fire1.png",
	"res://sprites/Fire2.png"
]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load(sprites[int(randf_range(0, 2))])
