class_name CharacterMovement extends Node

# https://www.youtube.com/watch?v=jSv5sGpnFso&list=PLHQtYtVDHcj6lnjNnPlWfvM-ehdgJaDVH

enum MOVEMENT_STATE { IDLE, TURNING, WALKING }

@export_group("Dependancy Nodes")
@export var character: Node2D
@export var animationPlayer: AnimationPlayer
@export var debugText: RichTextLabel
@export var collisionRaycast: RayCast2D

@export_group("Movement Constants")
@export var speed: float = 45.0
@export var snapDistance: float = 0.6

@export_group("Movement")
@export var inputDirection: Vector2 = Vector2.ZERO
@export var queuedInputDirection: Array[Vector2] = []
@export var movementState: MOVEMENT_STATE = MOVEMENT_STATE.IDLE
@export var queuedMovementState: MOVEMENT_STATE = MOVEMENT_STATE.IDLE


func _ready() -> void:
	#Logger.debug("Loading CharacterMovement component...")
	animationPlayer.connect("animation_finished", _on_AnimationPlayer_animation_finished)
	debugText.add_theme_font_size_override("normal_font_size", 8)
	animationPlayer.play("idle-down")

func registerMoveDirection(direction: Vector2) -> void:
	if len(queuedInputDirection) > 0 and queuedInputDirection[0] == direction:
		return
	elif isWalking() or isIdle() or isTurning():
		queuedMovementState = MOVEMENT_STATE.WALKING
		queuedInputDirection.erase(direction)
		queuedInputDirection.push_front(direction)
		#Logger.debug("registered WALK %s" % [Constants.VectorToString(direction)])

func deregisterMoveDirection(direction: Vector2) -> void:
	queuedInputDirection.erase(direction)
	#Logger.debug("DEregistered WALK %s %s" % [Constants.VectorToString(direction), direction])
	if len(queuedInputDirection) == 0:
		#Logger.debug("registered IDLE")
		queuedMovementState = MOVEMENT_STATE.IDLE

func _physics_process(delta: float) -> void:
	#_updateDebugText(_movementStateToString(movementState) + ", " + str(inputDirection))
	_updateDebugText(animationPlayer.current_animation)
	move(delta)
	
func move(delta: float) -> void:
	if isWalking():
		var movementDistance: float = speed * delta
		# get remaining distance to next grid cell
		var remainder: float = 0.0
		match Constants.VectorToDirection(inputDirection):
			Constants.DIRECTION.UP:
				remainder = fmod(character.position.y, Constants.GRID_SIZE)
			Constants.DIRECTION.DOWN:
				remainder = Constants.GRID_SIZE - fmod(character.position.y, Constants.GRID_SIZE)
			Constants.DIRECTION.LEFT:
				remainder = fmod(character.position.x, Constants.GRID_SIZE)
			Constants.DIRECTION.RIGHT:
				remainder = Constants.GRID_SIZE - fmod(character.position.x, Constants.GRID_SIZE)
		# check if close to next grid
		if remainder <= snapDistance:
			if _isBlocked():
				snapPositionToGrid()
				_fullStop()
				Logger.debug("Collision, stopped walking")
				return
			#Logger.debug("move queue: %s" % [queuedInputDirection])
			# if close to next grid and queued to idle
			if queuedMovementState == MOVEMENT_STATE.IDLE and len(queuedInputDirection) == 0:
				snapPositionToGrid()
				animationPlayer.play("idle-%s" % [Constants.VectorToString(inputDirection)])
				movementState = MOVEMENT_STATE.IDLE
				inputDirection = Vector2.ZERO
				#Logger.debug("Now idling")
				return
			# if close to next grid but still queued to walk
			elif queuedMovementState == MOVEMENT_STATE.WALKING:
				snapPositionToGrid()
				if len(queuedInputDirection) > 0 and queuedInputDirection[0] != inputDirection:
					movementState = MOVEMENT_STATE.TURNING
					animationPlayer.play("turn-%s" % Constants.VectorToString(queuedInputDirection[0]))
		# else just keep moving towards next grid cell
		character.position = character.position + (inputDirection * movementDistance)
		return
	elif isTurning():
		return
	elif isIdle():
		if queuedMovementState == MOVEMENT_STATE.WALKING:
			if len(queuedInputDirection) == 0:
				Logger.error("No queued movement direction when transitioning from idle to walking")
			var currentDirection: String = _animValues(animationPlayer.current_animation)["direction"]
			var queuedWalkDirection: String = Constants.VectorToString(queuedInputDirection[0])
			if currentDirection != queuedWalkDirection:
				#Logger.debug("turning %s from idle %s" % [queuedWalkDirection, currentDirection])
				movementState = MOVEMENT_STATE.TURNING
				animationPlayer.play("turn-%s" % queuedWalkDirection)
				return
			if _isBlocked():
				Logger.debug("Collision, will not start walking")
				return
			movementState = queuedMovementState
			inputDirection = queuedInputDirection[0]
			animationPlayer.play("walk-%s" % [Constants.VectorToString(inputDirection)])
			#Logger.debug("Now walking")
		return

# this helps keep the player aligned to the grid
func snapPositionToGrid() -> Vector2:
	character.position = Vector2(
		round(character.position.x / Constants.GRID_SIZE) * Constants.GRID_SIZE,
		round(character.position.y / Constants.GRID_SIZE) * Constants.GRID_SIZE
	)
	return character.position

func isWalking() -> bool:
	return movementState == MOVEMENT_STATE.WALKING

func isIdle() -> bool:
	return movementState == MOVEMENT_STATE.IDLE

func isTurning() -> bool:
	return movementState == MOVEMENT_STATE.TURNING

func _on_AnimationPlayer_animation_finished(animName: String) -> void:
	# act on finished turn animations
	if _getAnimationActionString(animName) == "turn":
		var animationDirection: String = _getFacingDirectionString(animName)
		# set colission raycast target position to be the facing direction
		# target position is relitive to position
		collisionRaycast.target_position = Constants.StringToVector(animationDirection) * Constants.GRID_SIZE
		# updating the raycast target_position takes some time
		await get_tree().create_timer(0.05).timeout
		Logger.debug("turning animation finished %s" % [animName])
		# should continue moving
		if len(queuedInputDirection) > 0:
			var nextQueuedMovementDirection: String = Constants.VectorToString(queuedInputDirection[0])
			# the next move direction doesn't match direction facing
			if nextQueuedMovementDirection != animationDirection:
				Logger.info("strange input behaviour. need to turn again. Completed turn direction %s , movement direction %s" % [animationDirection, nextQueuedMovementDirection])
				animationPlayer.play("turn-%s" % nextQueuedMovementDirection)
				return
			if _isBlocked():
				_fullStop(animName)
				Logger.debug("Collision after turn, will not start walking")
				return
			movementState = MOVEMENT_STATE.WALKING
			inputDirection = queuedInputDirection[0]
			animationPlayer.play("walk-%s" % animationDirection)
			Logger.debug("%s -> walk-%s" % [animName, animationDirection])
		# should stop moving
		else:
			movementState = MOVEMENT_STATE.IDLE
			inputDirection = Vector2.ZERO
			animationPlayer.play("idle-%s" % animationDirection)
			Logger.debug("%s -> idle-%s" % [animName, animationDirection])
		Logger.debug("walk queue after %s: %s" % [animName, queuedInputDirection])
			
func _updateDebugText(value: String) -> void:
	debugText.text = value

func _movementStateToString(moveState: MOVEMENT_STATE) -> String:
	var keys := MOVEMENT_STATE.keys()
	var keyValue: String = keys[moveState]
	return keyValue.to_lower()

func _animValues(animName: String) -> Dictionary:
	var values: PackedStringArray = animName.split("-")
	return {
		"action": values[0],
		"direction": values[1]
	}

func _fullStop(animName: String = "") -> void:
	movementState = MOVEMENT_STATE.IDLE
	queuedMovementState = MOVEMENT_STATE.IDLE
	queuedInputDirection = []
	animationPlayer.play("idle-%s" % _getFacingDirectionString(animName))

func _getFacingDirectionString(animName: String = "") -> String:
	if animName == "":
		animName = animationPlayer.current_animation
	# animation names are in the form "action-direction"
	var animation: PackedStringArray = animName.split("-")
	Logger.info("getFacingDirectionString animation: %s" % animName)
	return animation[1]
	
func _getAnimationActionString(animName: String = "") -> String:
	if animName == "":
		animName = animationPlayer.current_animation
	# animation names are in the form "action-direction"
	var animation: PackedStringArray = animName.split("-")
	return animation[0]

func _isBlocked() -> bool:
	Logger.debug("raycast target: %s" % collisionRaycast.target_position)
	var isColliding: bool = collisionRaycast.is_colliding()
	if isColliding:
		Logger.debug("Checked for collision and found")
	return isColliding
