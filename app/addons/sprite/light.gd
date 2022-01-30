tool
extends Button

export(Color) var color

func _ready() -> void:
	$label.text = str(color.r8 >> 4)
	
	self_modulate.r8 = (color.r8 >> 4) * 32
