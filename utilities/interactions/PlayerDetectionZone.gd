class_name PlayerDetectionZone extends Area2D

signal player_detected(player: CharacterBody2D)

var player: CharacterBody2D = null

func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
