class_name PlayerFieldPlayer
extends FieldPlayer

func _physics_process(_delta):
	var player_field_manager = field_manager as PlayerFieldManager
	if player_field_manager.selected_player == self:
		var new_velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			new_velocity.x += 1
		if Input.is_action_pressed("move_left"):
			new_velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			new_velocity.y += 1
		if Input.is_action_pressed("move_up"):
			new_velocity.y -= 1
		if !is_going_for_steal:
			linear_velocity = new_velocity.normalized() * SPEED

		if !is_playing_pass_or_shoot_anim:
			if new_velocity.length() != 0:
				sprite.play("run")
			else:
				sprite.play("idle")

		if linear_velocity.x < 0:
			sprite.flip_h = true
			curr_direction = Direction.LEFT
		elif linear_velocity.x > 0:
			sprite.flip_h = false
			curr_direction = Direction.RIGHT

		if has_possession:
			if Input.is_action_just_pressed("pass"):
				pass_ball()
			if Input.is_action_just_pressed("shoot"):
				shoot_ball()
			update_pass_target(linear_velocity)
		else:
			if Input.is_action_just_pressed("steal"):
				if is_able_to_steal() and is_within_steal_range():
					steal_ball()
	super._physics_process(_delta)

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

func take_poss_of_ball():
	super.take_poss_of_ball()
	var player_manager = field_manager as PlayerFieldManager
	player_manager.select_new_player(self)
