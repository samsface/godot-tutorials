extends Control

var i_ := 0

func _input(event):
	if Input.is_action_just_pressed("ui_right"):
		i_ += 1
		$picture_frame.texture = load("res://" + str(i_ % 4) + ".png")
