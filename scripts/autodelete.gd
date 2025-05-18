/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node2D

func _ready() -> void:
	$Audio.play()

func _on_delete_timer_timeout() -> void:
	queue_free()
