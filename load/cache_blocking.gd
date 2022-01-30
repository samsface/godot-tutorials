extends Node

var cache_ := []

func _ready():
	cache_.push_back(load("res://0.png"))
	cache_.push_back(load("res://1.png"))
	cache_.push_back(load("res://2.png"))
	cache_.push_back(load("res://3.png"))
