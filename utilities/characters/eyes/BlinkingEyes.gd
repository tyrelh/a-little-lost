extends Node2D

@onready var eyeRight: Sprite2D = $EyeRight
@onready var eyeLeft: Sprite2D = $EyeLeft
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@export var blinkRangeMax: float = 3.0
@export var blinkRangeMin: float = 0.1

const CLOSE_EYES_ANIMATION = "CloseEyes"

var _rng = RandomNumberGenerator.new()

func _ready() -> void:
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	_rng.randomize()
	timer.start(_rng.randf_range(blinkRangeMin, blinkRangeMax))


func blink_eyes() -> void:
	animationPlayer.play(CLOSE_EYES_ANIMATION)
#	yield(animationPlayer, "animation_finished")
#	animationPlayer.play_backwards(CLOSE_EYES_ANIMATION)
	

func _on_Timer_timeout() -> void:
	blink_eyes()
	timer.start(_rng.randf_range(blinkRangeMin, blinkRangeMax))
