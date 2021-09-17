extends Sprite

var delta_sum_ := 0.0

func _process(delta:float) -> void:
	delta_sum_ += delta
	
	if UtilsAuto.is_even(delta_sum_):
		return
	
	global_rotation += delta
