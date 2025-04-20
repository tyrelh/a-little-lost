extends CharacterBody2D

const STATE_IDLE: String = "Idle"
const STATE_WALK: String = "Walk"

@export var speed: int = 45
@export var state: String = STATE_IDLE
var current_direction: String = "down"
@onready var stateMachine = $AnimationTree["parameters/playback"]

#func _ready():
	#$AnimationPlayer.set("speed_scale", 0.1)

#func _physics_process(delta: float):
	#player_movement(delta)
#
#func player_movement(_delta: float):
	#
	## read input vector
	#var inputVector: Vector2 = Vector2.ZERO
	#inputVector.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	#inputVector.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	#
	#var inputTotal: float = inputVector.x + inputVector.y
	#if state == STATE_IDLE:
		#if inputVector != Vector2.ZERO:
			#state = STATE_WALK
			#stateMachine.travel(STATE_WALK)
	#elif state == STATE_WALK:
		#if inputVector == Vector2.ZERO:
			#state = STATE_IDLE
			#stateMachine.travel(STATE_IDLE)
	#
	## set animation
	#if inputVector != Vector2.ZERO:
		#$AnimationTree.set("parameters/Walk/blend_position", inputVector)
		#$AnimationTree.set("parameters/Idle/blend_position", inputVector)
	#
	#velocity = inputVector.normalized() * speed
	#
	#move_and_slide()
