extends Node

# logging & debugging
const DEBUG: bool = true

# world
const GRID_SIZE: int = 16
enum DIRECTION { UP, DOWN, LEFT, RIGHT }
func DirectionString(direction: DIRECTION) -> String:
	var keys := DIRECTION.keys()
	var keyValue: String = keys[direction]
	return keyValue.to_lower()
func VectorToDirection(vector: Vector2) -> DIRECTION:
	match vector:
		Vector2.UP:
			return DIRECTION.UP
		Vector2.DOWN:
			return DIRECTION.DOWN
		Vector2.LEFT:
			return DIRECTION.LEFT
		Vector2.RIGHT:
			return DIRECTION.RIGHT
		_:
			#Logger.error("Attempted to convert a non-cardinal Vector2 (%s) to a DIRECTION" % [vector])
			return DIRECTION.DOWN
func VectorToString(vector: Vector2) -> String:
	var direction: DIRECTION = VectorToDirection(vector)
	return DirectionString(direction)
