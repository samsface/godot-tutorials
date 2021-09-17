tool
extends Node2D

func _process(delta) -> void:
	if Engine.is_editor_hint():
		global_position = global_position.snapped(Vector2(1, 1))
