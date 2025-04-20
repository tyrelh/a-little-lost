class_name PlayerInput extends CharacterInput

#@export_group("Player Input")

@export_group("Dependant Nodes")
@export var playerMovement: CharacterMovement

func _ready() -> void:
	Logger.debug("Loading PlayerInput component...")

func _physics_process(delta: float) -> void:
	processPlayerInput()
	
func processPlayerInput() -> void:
	if Input.is_action_just_pressed("move_down"):
		playerMovement.registerMoveDirection(Vector2.DOWN)
	if Input.is_action_just_pressed("move_up"):
		playerMovement.registerMoveDirection(Vector2.UP)
	if Input.is_action_just_pressed("move_left"):
		playerMovement.registerMoveDirection(Vector2.LEFT)
	if Input.is_action_just_pressed("move_right"):
		playerMovement.registerMoveDirection(Vector2.RIGHT)
	
	if Input.is_action_just_released("move_down"):
		playerMovement.deregisterMoveDirection(Vector2.DOWN)
	if Input.is_action_just_released("move_up"):
		playerMovement.deregisterMoveDirection(Vector2.UP)
	if Input.is_action_just_released("move_left"):
		playerMovement.deregisterMoveDirection(Vector2.LEFT)
	if Input.is_action_just_released("move_right"):
		playerMovement.deregisterMoveDirection(Vector2.RIGHT)
