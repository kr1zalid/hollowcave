extends CharacterBody2D

const MAX_SPEED = 150
const ACELERATION_SMOOTHING = 15



func _ready():
	pass
	
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1- exp(-delta *ACELERATION_SMOOTHING))
	
	move_and_slide()
	
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
	
	
