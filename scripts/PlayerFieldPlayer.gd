class_name PlayerFieldPlayer
extends FieldPlayer

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

func take_poss_of_ball():
	super.take_poss_of_ball()
	is_selected = true