class_name CharacterMovement extends Node

# https://www.youtube.com/watch?v=jSv5sGpnFso&list=PLHQtYtVDHcj6lnjNnPlWfvM-ehdgJaDVH

signal animation_event()

const STATE_IDLE: String = "Idle"
const STATE_WALK: String = "Walk"

@export_group("Dependancy Nodes")
@export var character: Node2D
@export var animationTree: AnimationTree

@export_group("Movement")
@export var isWalking: bool = false
@export var speed: float = 2.0
@export var initialPosition: Vector2
@export var inputDirection: Vector2 = Vector2.ZERO
@export var percentMovedToNextTile: float = 0.0

@onready var stateMachine = animationTree["parameters/playback"]

func _ready() -> void:
	Logger.debug("Loading CharacterMovement component...")
	initialPosition = character.position
	stateMachine.travel("Idle")

func _physics_process(delta: float) -> void:
	if isWalking and inputDirection != Vector2.ZERO:
		move(inputDirection, delta)
		
		#$AnimationTree.set("parameters/Walk/blend_position", inputVector)
		#$AnimationTree.set("parameters/Idle/blend_position", inputVector)

func move(direction: Vector2, delta: float) -> void:
	if isWalking:
		percentMovedToNextTile += speed * delta
		if percentMovedToNextTile >= 1.0:
			percentMovedToNextTile = 0.0
			isWalking = false
			stateMachine.travel("Idle")
			animationTree.set("parameters/Idle/blend_position", inputDirection)
			inputDirection = Vector2.ZERO
			initialPosition = snapPositionToGrid()
		else:
			animationTree.set("parameters/Walk/blend_position", inputDirection)
			character.position = initialPosition + (Constants.GRID_SIZE * inputDirection * percentMovedToNextTile)
			
	elif direction != Vector2.ZERO:
		isWalking = true
		inputDirection = direction
		stateMachine.travel("Walk")
		

func snapPositionToGrid() -> Vector2:
	character.position = Vector2(
		round(character.position.x / Constants.GRID_SIZE) * Constants.GRID_SIZE,
		round(character.position.y / Constants.GRID_SIZE) * Constants.GRID_SIZE
	)
	return character.position
