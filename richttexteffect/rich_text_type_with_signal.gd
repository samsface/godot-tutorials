tool
extends RichTextEffect
class_name RichTextTypeWithSignal

signal new_char_visible

var bbcode := "type_and_emit"

func _process_custom_fx(char_fx:CharFXTransform) -> bool:
	var speed:float = 1.0 - char_fx.env.get("speed", 0.0)
	var progress = int(char_fx.elapsed_time / speed)

	if char_fx.absolute_index > progress:
		char_fx.color.a = 0.0

	if progress != char_fx.env.get("progress", -1):
		char_fx.env["progress"] = progress
		emit_signal("new_char_visible", progress)

	return true
