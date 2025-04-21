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
	Logger.error("Attempted to convert a non-cardinal Vector2 (%s) to a DIRECTION" % [vector])
	return DIRECTION.DOWN
	
func VectorToString(vector: Vector2) -> String:
	var direction: DIRECTION = VectorToDirection(vector)
	return DirectionString(direction)
	
func StringToVector(stringVal: String) -> Vector2:
	var stringValLower: String = stringVal.to_lower().strip_edges()
	match stringValLower:
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		"left":
			return Vector2.LEFT
		"right":
			return Vector2.RIGHT
	Logger.error("Attempted to convert a non-cardinal String (%s) to a Vector2" % stringVal)
	return Vector2.ZERO
