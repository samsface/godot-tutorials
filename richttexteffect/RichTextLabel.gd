extends RichTextLabel

func _ready():
	# must loop by index here
	for i in custom_effects:
		if i is RichTextTypeWithSignal:
			i.connect("new_char_visible", self, "_on_new_char_visible")

func _on_new_char_visible(char_length) -> void:
	print(char_length)
	if char_length > 21:
		$particles.emitting = true
