extends Control

var i_ := 0
var done_loading_ := false

func _ready() -> void:
	$cache.connect("progress", self, "_on_progress")
	$cache.connect("done", self, "_on_done")

func _on_progress(progress:int) -> void:
	$progress.text = "loading " + str(progress)

func _on_done() -> void:
	done_loading_ = true
	$progress.text = "loaded!"

func _input(event):
	if not done_loading_:
		return

	if Input.is_action_just_pressed("ui_right"):
		i_ += 1
		$picture_frame.texture = load("res://" + str(i_ % 4) + ".png")
