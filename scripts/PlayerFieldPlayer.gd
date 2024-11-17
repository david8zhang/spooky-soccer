class_name PlayerFieldPlayer
extends FieldPlayer

func _physics_process(_delta):
	var player_field_manager = field_manager as PlayerFieldManager
	if player_field_manager.selected_player == self:
		highlight()
		linear_velocity = Vector2.ZERO
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
			if Input.is_action_just_pressed("pass"):
				pass_ball()
			if Input.is_action_just_pressed("shoot"):
				shoot_ball()
			update_pass_target(linear_velocity)
		else:
			if Input.is_action_just_pressed("steal"):
				if can_steal():
					steal_ball()
	else:
		dehighlight()
	super._physics_process(_delta)

func can_steal():
	var ball_handler = game.get_ball_handler()
	if ball_handler != null:
		var dist_to_ball_handler = global_position.distance_to(ball_handler.global_position)
		return dist_to_ball_handler <= FieldPlayer.STEAL_RANGE
	else:
		return false

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
	pass_target = closest_player

func dehighlight():
	var _material = sprite.material as ShaderMaterial
	_material.set_shader_parameter('width', 0)

func highlight():
	var _material = sprite.material as ShaderMaterial
	_material.set_shader_parameter('color', Color(0, 1.0, 0, 1))
	_material.set_shader_parameter('width', 1)

func take_poss_of_ball():
	super.take_poss_of_ball()
	var player_manager = field_manager as PlayerFieldManager
	player_manager.select_new_player(self)