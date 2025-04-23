class_name CrowGeneric extends CharacterBody2D

enum {
	CROW_IDLE_STATE,
	CROW_TAKEOFF_STATE,
	CROW_LANDING_STATE,
	CROW_WANDER_STATE
	}

const CROW_IDLE_ANIMATION = "idle-left"
const CROW_TAKEOFF_ANIMATION = "takeoff-left"
const CROW_FLY_ANIMATION = "fly-left"

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var _state = CROW_IDLE_STATE
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	# add a small random delay to the beginning of the looping animation so that all crows aren't moving in syncrony
	animationPlayer.play(CROW_IDLE_ANIMATION, -1, rng.randf_range(0.8, 1.0))


func _process(delta: float) -> void:
	check_for_player()
	match _state:
		CROW_IDLE_STATE:
			do_idle(delta)
		CROW_WANDER_STATE:
			do_wander()


func do_idle(_delta: float) -> void:
	pass


func do_wander() -> void:
	pass


func check_for_player():
	if (_state == CROW_IDLE_STATE && playerDetectionZone.can_see_player()):
		_state = CROW_TAKEOFF_STATE
		animationPlayer.play(CROW_TAKEOFF_ANIMATION)
	elif (_state == CROW_WANDER_STATE && !playerDetectionZone.can_see_player()):
		_state = CROW_LANDING_STATE
		animationPlayer.play_backwards(CROW_TAKEOFF_ANIMATION)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == CROW_TAKEOFF_ANIMATION && _state == CROW_TAKEOFF_STATE):
		_state = CROW_WANDER_STATE
		animationPlayer.play(CROW_FLY_ANIMATION)
	elif (anim_name == CROW_TAKEOFF_ANIMATION && _state == CROW_LANDING_STATE):
		_state = CROW_IDLE_STATE
		animationPlayer.play(CROW_IDLE_ANIMATION)
