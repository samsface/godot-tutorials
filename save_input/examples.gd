extends Node2D

func _process(delta:float) -> void:
	if Input.is_action_just_pressed("click"):
		var task := Task.new()
		task.action = "move"
		task.position = get_global_mouse_position()
		
		for worker in get_children():
			worker.queue_task(task)
