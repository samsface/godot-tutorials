tool
extends RichTextEffect
class_name RichTextType

var bbcode := "type"

func _process_custom_fx(char_fx:CharFXTransform) -> bool:
	var speed:float = 1.0 - float(char_fx.env.get("speed", 0.0))
	var progress = int(char_fx.elapsed_time / speed)

	if char_fx.absolute_index > progress:
		char_fx.color.a = 0.0

	return true
