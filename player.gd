extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_velocity = -500
const ACCELERATION = 100.0
const FRICTION = 0.01
var current_velocity = Vector2()


func _physics_process(delta):
	var direction = 0
	var speed = (2*PI*$CollisionShape2D.shape.radius)
	var target_velocity = Vector2()
	
	if Input.is_action_pressed("jump") and is_on_floor():
		target_velocity.y = jump_velocity
	
	if Input.is_action_pressed("move_left") and is_on_floor():
		target_velocity.x = -speed
		
	if Input.is_action_pressed("move_right") and is_on_floor():
		target_velocity.x = speed
		
	if target_velocity.x != 0:
		current_velocity.x = lerp(current_velocity.x, target_velocity.x, ACCELERATION * delta)
	if is_on_floor():
		current_velocity.x = lerp(current_velocity.x, 0.0, FRICTION)
	if is_on_ceiling():
		current_velocity.y = 0
		current_velocity.x = lerp(current_velocity.x, 0.0, FRICTION * 10)

	if abs(current_velocity.x) > $CollisionShape2D.shape.radius/2:
		$AnimatedSprite2D.play()
		if velocity.x > 0:
			$AnimatedSprite2D.speed_scale = sqrt(velocity.x) / 10
		else:
			$AnimatedSprite2D.speed_scale = -sqrt(-velocity.x) / 10
	else:
		current_velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.pause()
		else:
			$AnimatedSprite2D.stop()
	
	if is_on_floor():
		$AnimatedSprite2D.animation = &"walk"
		$AnimatedSprite2D.flip_h = false
		if target_velocity.y != 0:
			current_velocity.y = target_velocity.y
		else:
			current_velocity.y = velocity.y
	else:
		$AnimatedSprite2D.animation = &"jump"
		$AnimatedSprite2D.flip_h = current_velocity.x < 0
		current_velocity.y += gravity * delta
		if current_velocity.y > $CollisionShape2D.shape.radius * 23:
			$AnimatedSprite2D.animation = &"fall"
		
	velocity = current_velocity
	
	move_and_slide()


func start(pos):
	position = pos
	show()
