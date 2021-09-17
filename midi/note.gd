extends Sprite

export(float)  var expected_time
export(Color)  var color setget set_color

var state_ := ""

func set_color(value:Color) -> void:
	color = value
	self_modulate = color

func test_hit(time:float) -> bool:
	if abs(expected_time - time) < 0.2:
		return true
	return false

func test_miss(time:float) -> bool:
	if time > expected_time + 0.2:
		return true
	return false

func hit(position_to_freeze:Vector2) -> void:
	state_ = "hit"
	global_position = position_to_freeze
	
func miss() -> void:
	state_ = "miss"

func _process(delta):
	if state_ == "hit":
		queue_free()
		return

	global_position.y += delta * 500.0
		
	if state_ == "miss":
		if global_position.y > 600.0:
			queue_free()
