extends Node2D

class Actor extends Reference:
	var friend

func _process(delta) -> void:
	var homer = Actor.new()       # homer ref count == 1
	var lenny = Actor.new()       # lenny ref count == 1
	
	homer.friend = weakref(lenny) # lenny ref count == 1
	lenny.friend = weakref(homer) # homer ref count == 1

	# homer goes out of scope
	# homer ref count -= 1
	# homer ref count == 0, lenny ref count == 1

	# lenny goes out of scope
	# lenny ref count -= 1
	# homer ref count == 0, lenny ref count = 0
