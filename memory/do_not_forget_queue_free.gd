extends Node2D

func _ready() -> void:
	if not get_node_or_null("green_square"):
		var parent     := Sprite.new()
		parent.name     = "green_square"
		parent.texture  = preload("res://icon2.png")
		parent.position = Vector2(256, 256)
		parent.centered = false
		add_child(parent)

func _process(delta:float) -> void:
	
	
	if $green_square.get_child_count() < 100:
		var sprite     := Sprite.new()
		sprite.texture  = preload("res://icon.png")
		sprite.position = Vector2(rand_range(0, 256), rand_range(0, 256))
		$green_square.add_child(sprite)

func _on_queue_free_pressed():
	$green_square.queue_free()
	set_process(false)

func _on_remove_child_pressed():
	remove_child($green_square) # should store $parent in variable to queue_free on exit tree
	set_process(false)
	
func _on_change_scenen():
	get_tree().change_scene("res://do_not_forget_queue_free.tscn")
