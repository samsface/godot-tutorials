tool
extends ColorPickerButton

func _on_color_changed(color : Color):
	print(color)
	$rect.color = color


func _on_popup_closed():
	print(color)

func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.doubleclick:
			get_popup().show_modal()
