extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta) -> void:
	var velocity := Vector2()
	var speed    := 100.0
	
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT

	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2.DOWN

	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP

	global_position += velocity * delta * speed
	
	if get_global_mouse_position().x < global_position.x:
		scale.x = -1
	else:
		scale.x = 1
		
	$gun.look_at(get_global_mouse_position())













