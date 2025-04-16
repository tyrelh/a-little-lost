class_name CharacterInput extends Node

signal walk_event()
signal turn_event()

@export_group("Common Input")
@export var direction: Vector2 = Vector2.ZERO
@export var targetPosition: Vector2 = Vector2.ZERO

func _ready() -> void:
	Logger.info("Loading PlayerInput component...")
