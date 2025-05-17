extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
var timeDelta = 0
func _process(delta: float) -> void:
	timeDelta = timeDelta + delta
	if timeDelta > 0.05:
		timeDelta =0
		if int(randf_range(0,10)) == 1:
			frame = posmod(frame + 1, 2)
