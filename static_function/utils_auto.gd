extends Node

func _enter_tree():
	UtilsAuto2.foo()

func foo():
	print('hi')

func is_even(number) -> bool:
	return !(int(number) % 2)
