class_name PlayerInput extends CharacterInput

@export_group("Player Input")
#@export var holdThreshold: float = 0.1
#@export var holdTime: float = 0.0
@export var inputDirection: Vector2 = Vector2.ZERO

@export_group("Nodes")
@export var playerMovement: CharacterMovement

func _ready() -> void:
	Logger.info("Loading PlayerInput component...")

func _physics_process(delta: float) -> void:
	processPlayerInput(delta)
		
func processPlayerInput(delta: float) -> void:
	if inputDirection.y == 0:
		inputDirection.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if inputDirection.x ==0:
		inputDirection.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	if inputDirection != Vector2.ZERO:
		playerMovement.move(inputDirection, delta)
