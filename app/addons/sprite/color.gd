tool
extends Button

export(Color) var color

func _ready() -> void:
	hint_tooltip = str(color.r8)

	if material:
		material.set_shader_param("color", color)

