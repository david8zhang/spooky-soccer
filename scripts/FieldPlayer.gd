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

enum Side {
	PLAYER,
	CPU
}

enum Direction {
	LEFT,
	RIGHT
}

@onready var game = get_node("/root/Main") as Game
var field_manager

func _physics_process(_delta):
	linear_velocity = Vector2.ZERO
	if is_selected:
		if Input.is_action_pressed("move_right"):
			linear_velocity.x += 1
		if Input.is_action_pressed("move_left"):
			linear_velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			linear_velocity.y += 1
		if Input.is_action_pressed("move_up"):
			linear_velocity.y -= 1

		if linear_velocity.length() > 0:
			linear_velocity = linear_velocity.normalized() * SPEED

		if linear_velocity.x < 0:
			curr_direction = Direction.LEFT
		elif linear_velocity.x > 0:
			curr_direction = Direction.RIGHT

	if has_possession:
		# Pass ball
		if Input.is_action_just_pressed("pass"):
			pass_ball()

		if Input.is_action_just_pressed("shoot"):
			shoot_ball()

		var ball = game.ball as RigidBody2D
		var x_diff = -50 if curr_direction == Direction.LEFT else 50
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y)
		update_pass_target(linear_velocity)


func update_pass_target(curr_velocity: Vector2):
	var src_position = global_position + curr_velocity
	var closest_player
	var min_dist = INF
	for player in field_manager.field_players:
		if player != self:
			var dist = src_position.distance_to(player.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_player = player

	# Update pass target
	if pass_target != null and pass_target != closest_player:
		pass_target.hide_highlight()
	pass_target = closest_player
	if has_possession and side == Side.PLAYER:
		pass_target.show_highlight()

func show_highlight():
	self.modulate = Color(255, 0, 0, 0.25)

func hide_highlight():
	self.modulate = Color.WHITE

func pass_ball():
	if pass_target != null:
		can_take_possession = false
		var ball = game.ball as Ball
		var dir = (pass_target.global_position - ball.global_position).normalized()
		var velocity_vector = dir * PASS_SPEED
		ball.linear_velocity = velocity_vector
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER_PASS
		ball.prev_possessor = self
		ball.enable_collision_detector()
		is_selected = false
		lose_poss_of_ball()

func shoot_ball():
	can_take_possession = false
	var ball = game.ball
	var opp_goal = get_opposing_goal()
	var dir = (opp_goal.global_position - ball.global_position).normalized()
	var velocity_vector = dir * SHOOT_SPEED
	ball.prev_possessor = self
	ball.enable_collision_detector()
	ball.linear_velocity = velocity_vector
	lose_poss_of_ball()

func handle_ball_collision():
	var ball = game.ball as Ball
	if can_take_possession:
		if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER_PASS:
			if ball.prev_possessor != null:
				ball.prev_possessor.can_take_possession = true
		take_poss_of_ball()

func get_opposing_goal():
	return game.cpu_goal if side == Side.PLAYER else game.player_goal

func on_completed_pass():
	is_selected = false
	can_take_possession = true
	pass_target = null

func take_poss_of_ball():
	hide_highlight()
	var ball = game.ball as Ball
	ball.disable_collision_detector()
	has_possession = true

	if side == Side.PLAYER:
		is_selected = true

func lose_poss_of_ball():
	has_possession = false
