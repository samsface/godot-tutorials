extends Sprite

var delta_sum_ := 0.0

func _process(delta:float):
	delta_sum_ += delta
	position.x += sin(delta_sum_ * 10.0) * 10.0
	position.y += cos(delta_sum_ * 10.0) * 10.0
