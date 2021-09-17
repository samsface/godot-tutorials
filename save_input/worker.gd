extends Sprite

export(float, 0.0, 1.0) var speed := 1.0

var tasks_ := []

func _ready():
	pass
	
func _process(delta:float) -> void:
	if tasks_.empty():
		return

	if tasks_.front().action == "move":
		do_move_task_(delta, tasks_.front())

func do_move_task_(delta:float, task:Task) -> void:
	global_position = global_position.move_toward(task.position, delta * 300.0 * speed)
	
	if global_position.distance_to(task.position) < 0.1:
		var p = tasks_.pop_front()
		p.queue_free()
			
func queue_task(task) -> void:
	tasks_.push_back(task)
