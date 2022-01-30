tool
extends Button

export(Color) var color

func _ready() -> void:
	$label.text = str(color.b8 >> 4)
	
	self_modulate.b = color.b
