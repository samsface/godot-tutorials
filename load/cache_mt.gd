extends Node

signal done
signal progress

var cache_ := []

var thread_ := Thread.new()

func _ready():
	thread_.start(self, "load_stuff", "no_use")

func load_stuff(no_use) -> void:
	var to_load := ["res://0.png", "res://1.png", "res://2.png", "res://3.png"]

	for i in to_load.size():
		cache_.push_back(load(to_load[i]))
		call_deferred("emit_signal", "progress", i + 1)

	call_deferred("emit_signal", "done")

func _exit_tree():
	thread_.wait_to_finish()
