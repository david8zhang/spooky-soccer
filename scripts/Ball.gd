class_name Ball
extends RigidBody2D

enum POSS_STATUS {
	PLAYER,
	CPU,
	PLAYER_PASS,
	CPU_PASS,
	SHOT_ON_PLAYER_GOAL,
	SHOT_ON_CPU_GOAL
}

@onready var collision_detector = $CollisionDetector/CollisionShape2D

func disable_collision_detector():
	collision_detector.set_deferred("disabled", true)

func enable_collision_detector():
	collision_detector.set_deferred("disabled", false)

var curr_poss_status
var prev_possessor

func _on_field_player_detector_body_entered(body):
	if body is FieldPlayer:
		var field_player = body as FieldPlayer
		field_player.handle_ball_collision()
	if body is Goal:
		var goal = body as Goal
		goal.handle_ball_collision(self)
