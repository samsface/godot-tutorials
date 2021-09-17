extends Button

var delta_sum_ := 0.0

func _process(delta:float) -> void:
	delta_sum_ += delta
	
	if Utils.is_even(delta_sum_):
		return
	
	rect_scale.x += sin(delta_sum_ * 10.0) * 0.01
