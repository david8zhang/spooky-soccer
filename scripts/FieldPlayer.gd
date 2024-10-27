class_name FieldPlayer
extends RigidBody2D

const SPEED = 300.0
const PASS_SPEED = 500.0
const SHOOT_SPEED = 750

var is_selected = false
var has_possession = false
var can_take_possession = true
var curr_direction
var pass_target
var player_name
var side

# Stamina damage to goalkeeper from shot
var shot_force = 100

enum Side {
	PLAYER,
	CPU
}

enum Direction {
	LEFT,
	RIGHT
}

@onready var game = get_node("/root/Main") as Game
var field_manager: FieldManager

func _physics_process(_delta):
	if has_possession:
		var ball = game.ball as RigidBody2D
		ball.show()
		var x_diff = -50 if curr_direction == Direction.LEFT else 50
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y)

func pass_ball():
	if pass_target != null:
		can_take_possession = false
		var ball = game.ball as Ball
		var dir = (pass_target.global_position - ball.global_position).normalized()
		var velocity_vector = dir * PASS_SPEED
		ball.linear_velocity = velocity_vector
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER_PASS
		ball.metadata["prev_possessor"] = self
		ball.enable_collision_detector()
		is_selected = false
		lose_poss_of_ball()

func shoot_ball():
	can_take_possession = false
	var ball = game.ball
	var opp_goal = get_opposing_goal()
	var dir = (opp_goal.global_position - ball.global_position).normalized()
	var velocity_vector = dir * SHOOT_SPEED
	ball.curr_poss_status = Ball.POSS_STATUS.SHOT_ON_CPU_GOAL
	ball.metadata["prev_possessor"] = self
	ball.metadata["shot_force"] = shot_force
	ball.enable_collision_detector()
	ball.linear_velocity = velocity_vector
	lose_poss_of_ball()

func handle_ball_collision():
	var ball = game.ball as Ball
	if can_take_possession:
		if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER_PASS:
			var prev_possessor = ball.metadata["prev_possessor"]
			if prev_possessor != null:
				prev_possessor.can_take_possession = true
		take_poss_of_ball()

func get_opposing_goal():
	return game.cpu_goal if side == Side.PLAYER else game.player_goal

func on_completed_pass():
	is_selected = false
	can_take_possession = true
	pass_target = null

func take_poss_of_ball():
	var ball = game.ball as Ball
	ball.disable_collision_detector()
	has_possession = true

func lose_poss_of_ball():
	has_possession = false

func side_has_possession():
	for p in field_manager.field_players:
		if p.has_possession:
			return true
	return false


func move_to_position(dest_position: Vector2, is_at_pos_threshold):
	if global_position.distance_to(dest_position) <= is_at_pos_threshold:
		linear_velocity = Vector2.ZERO
	else:
		var dir = (dest_position - global_position).normalized()
		linear_velocity = dir * FieldPlayer.SPEED