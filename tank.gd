extends CharacterBody2D
func _physics_process(delta: float) -> void:
	velocity.x = 10
	velocity.y = -10
	move_and_slide()
