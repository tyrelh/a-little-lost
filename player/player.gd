extends CharacterBody2D

const speed = 40
var current_direction = "down"

func _ready():
	play_animation(false)

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta: float):
	if Input.is_action_pressed("move_up"):
		current_direction = "up"
		velocity.x = 0
		velocity.y = -speed
		play_animation(true)
	elif Input.is_action_pressed("move_down"):
		current_direction = "down"
		velocity.x = 0
		velocity.y = speed
		play_animation(true)
	elif Input.is_action_pressed("move_left"):
		current_direction = "left"
		velocity.x = -speed
		velocity.y = 0
		play_animation(true)
	elif Input.is_action_pressed("move_right"):
		current_direction = "right"
		velocity.x = speed
		velocity.y = 0
		play_animation(true)
	else:
		velocity.x = 0
		velocity.y = 0
		play_animation(false)

	move_and_slide()

func play_animation(isMoving: bool):
	var direction = current_direction
	var animation = $AnimatedSprite2D

	if direction == "right":
		animation.flip_h = true
		if isMoving:
			animation.play("player-walk-side")
		else:
			animation.play("player-idle-side")
	elif direction == "left":
		animation.flip_h = false
		if isMoving:
			animation.play("player-walk-side")
		else:
			animation.play("player-idle-side")
	elif direction == "up":
		animation.flip_h = false
		if isMoving:
			animation.play("player-walk-back")
		else:
			animation.play("player-idle-back")
	elif direction == "down":
		animation.flip_h = false
		if isMoving:
			animation.play("player-walk-front")
		else:
			animation.play("player-idle-front")
