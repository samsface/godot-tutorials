extends Node2D

class CreateDrunkenTerrainJob extends Job:
	var offset := Vector2()

	func _init(request:Node, callback:String, offset:Vector2).(request, callback) -> void:
		self.offset = offset

	func _load() -> Array:
		var to_instance := []

		var closed := {}
		for t in ["water", "grass"]:
			for j in range(5):
				var walker_position := self.offset
				for i in range(10000):
					if not closed.has(walker_position):
						closed[walker_position] = true
						to_instance.push_back({"position": walker_position, "resource": load("res://" + t + ".tscn")})
					walker_position += Vector2(randi() % 2, randi() % 2) * (-1.0 if randf() >= 0.5 else 1.0)
		
		return to_instance

	func _instance(to_instance) -> void:
		var instance      = to_instance.resource.instance()
		instance.position = to_instance.position * 16.0

		self.staging_node.add_child(instance)

func create_terrain_with_drunk_walk(offset:Vector2):
	var model := {}

	for t in ["water", "grass"]:
		for j in range(5):
			var walker_position := offset
			for i in range(10000):
				if not model.has(walker_position):
					model[walker_position] = load("res://" + t + ".tscn").instance()
					model[walker_position].position = walker_position * 16.0
					add_child(model[walker_position])
				walker_position += Vector2(randi() % 2, randi() % 2) * (-1.0 if randf() >= 0.5 else 1.0)

func _ready():
	#create_terrain_with_drunk_walk(Vector2())
	Worker.post_job(CreateDrunkenTerrainJob.new(self, "_make_terrain_job_done", Vector2()))

func _make_terrain_job_done(job:CreateDrunkenTerrainJob) -> void:
	add_child(job.staging_node)
