extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var color = get_parent().get_parent().get_node("ColorPicker").color
	text = str(color.r8) + "/255.0 = UV(" + str(stepify(color.r, 0.01)) + ", 0)"
