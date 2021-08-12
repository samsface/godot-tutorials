extends Reference
class_name Job

var requester           :Node
var staging_node        :Node
var callback_func       :String
var instance_batch_size := 100
var to_instance_        := []

func _init(requester:Node, callback_func:String) -> void:
	self.requester     = requester
	self.callback_func = callback_func

func __load() -> void:
	to_instance_ = _load()

func _load() -> Array:
	return []

func _add_staging_node() -> void:
	staging_node = Node2D.new()
	Worker.add_child(staging_node)

func _remove_staging_node() -> void:
	staging_node.get_parent().remove_child(staging_node)

func _instance(to_instance):
	pass

func __instance():
	for i in range(to_instance_.size()):
		if i % instance_batch_size == 0:
			yield()
		
		_instance(to_instance_[i])

func _on_requester_invalid() -> void:
	pass
