class_name FieldPlayer
extends CharacterBody2D

const SPEED = 300.0
var is_selected = false
var has_possession = false
var curr_direction
var pass_target

enum Direction {
	LEFT,
	RIGHT
}

@onready var game = get_node("/root/Main") as Game
var field_manager

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if is_selected:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED

		if velocity.x < 0:
			curr_direction = Direction.LEFT
		elif velocity.x > 0:
			curr_direction = Direction.RIGHT

	if has_possession:
		# Pass ball
		if Input.is_action_just_pressed("pass"):
			pass_ball()

		var ball = game.ball as RigidBody2D
		var x_diff = -50 if curr_direction == Direction.LEFT else 50
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y)
	update_pass_target(velocity)
	move_and_slide()


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
	if has_possession:
		pass_target.show_highlight()

func show_highlight():
	self.modulate = Color(255, 0, 0, 0.25)

func hide_highlight():
	self.modulate = Color.WHITE

func pass_ball():
	if pass_target != null:
		lose_poss_of_ball()
		var ball = game.ball
		ball.show()
		ball.global_position = self.global_position
		ball.set_gravity_scale(0)
		var tween = create_tween()
		tween.tween_property(ball, "global_position", pass_target.global_position, 0.5)
		var cb = Callable(self, "on_completed_pass").bind(pass_target)
		tween.finished.connect(cb)

func on_completed_pass(target):
	is_selected = false
	target.take_poss_of_ball()
	target.is_selected = true
	pass_target = null

func take_poss_of_ball():
	hide_highlight()
	has_possession = true

func lose_poss_of_ball():
	has_possession = false
