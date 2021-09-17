tool
extends Sprite

export(bool)  var pressed setget set_pressed
export(Color) var color

func set_pressed(value:bool) -> void:
	pressed = value

func _ready():
	pass

func _process(delta:float) -> void:
	if pressed:
		modulate = lerp(modulate, color, 1.0)
		scale.y  = lerp(scale.y, 0.95, 1.0)
		scale.x  = lerp(scale.x, 0.95, 1.0)
	else:
		modulate = lerp(modulate, Color.gray, delta * 10.0)
		scale.y  = lerp(scale.y, 1.0, delta * 10.0)
		scale.x  = lerp(scale.x, 1.0, delta * 10.0)
