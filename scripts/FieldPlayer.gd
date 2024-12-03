class_name FieldPlayer
extends RigidBody2D

const SPEED = 250
const PASS_SPEED = 600
const STEAL_LUNGE_SPEED = 750
const SHOOT_SPEED = 750
const BALL_DRIBBLE_GAP = 40
const STEAL_RANGE = 100
const DEFAULT_STUN_SECONDS = 2

var has_possession = false
var is_on_pass_cooldown = false
var is_moving_to_position = false
var is_stunned = false
var curr_direction
var pass_target
var player_name
var side

# Going for a steal (slide tackle)
var steal_direction = Vector2.ZERO
var is_going_for_steal = false

# Stamina damage to goalkeeper from shot
var shot_force = 30

enum Side {
	PLAYER,
	CPU
}

enum Direction {
	LEFT,
	RIGHT
}

@onready var game = get_node("/root/Main") as Game
@onready var context_map = $ContextMap as ContextMap
@onready var ray_to_goal = $RayToGoal as RayCast2D
@onready var ray_to_allies = []
@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var steal_hitbox = $StealHitBox as Area2D

var field_manager: FieldManager

func _ready():
	game.all_ready.connect(all_ready)
	steal_hitbox.connect("body_entered", on_steal_hitbox_collided)

func all_ready():
	# Instantiate raycast to ally players (for determining passing lane states)
	for player in field_manager.field_players:
		if player != self:
			var ray_to_ally = RayCast2D.new() as RayCast2D
			ray_to_ally.target_position = ray_to_ally.to_local(player.global_position)
			update_ray_collision_based_on_side(ray_to_ally)
			add_child(ray_to_ally)
			var ray_to_ally_mapping = {
				"raycast": ray_to_ally,
				"player_ref": player
			}
			ray_to_allies.append(ray_to_ally_mapping)

	if ray_to_goal != null:
		update_ray_collision_based_on_side(ray_to_goal)
	if context_map != null:
		context_map.update_ray_collision_based_on_side()

func update_ray_collision_based_on_side(ray: RayCast2D):
	if side == Side.PLAYER:
		ray.set_collision_mask_value(1, false)
		ray.set_collision_mask_value(2, true)
	else:
		ray.set_collision_mask_value(1, true)
		ray.set_collision_mask_value(2, false)

func update_ray_to_ally_mappings():
	for mapping in ray_to_allies:
		var raycast = mapping["raycast"] as RayCast2D
		var player_ref = mapping["player_ref"] as FieldPlayer
		raycast.target_position = raycast.to_local(player_ref.global_position)

func _physics_process(_delta):
	if has_possession:
		var ball = game.ball as RigidBody2D
		ball.show()
		var x_diff = -BALL_DRIBBLE_GAP if curr_direction == Direction.LEFT else BALL_DRIBBLE_GAP
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y + 20)

	# For checking if the player currently has an open shot on offense
	if ray_to_goal != null:
		ray_to_goal.target_position = ray_to_goal.to_local(get_opposing_goal().global_position)
	update_ray_to_ally_mappings()

func pass_ball():
	if pass_target != null && !is_stunned:
		var ball = game.ball
		# Face toward pass_target
		curr_direction = Direction.LEFT if global_position.x > pass_target.global_position.x else Direction.RIGHT
		var x_diff = -BALL_DRIBBLE_GAP if curr_direction == Direction.LEFT else BALL_DRIBBLE_GAP
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y + 20)

		var pass_time = 0.5
		var dist_to_target = pass_target.global_position.distance_to(global_position)
		var pass_speed = dist_to_target / pass_time

		# Pass ball to where the target is going to be instead of where the target is
		var dead_reckoning_pos = pass_target.global_position + pass_target.linear_velocity * 0.5

		is_on_pass_cooldown = true
		var dir = (dead_reckoning_pos - ball.global_position).normalized()
		var velocity_vector = dir * pass_speed
		ball.linear_velocity = velocity_vector
		ball.curr_poss_status = Ball.POSS_STATUS.LOOSE
		lose_poss_of_ball()

		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = 0.1
		var on_timeout = Callable(self, "pass_cooldown")
		timer.connect("timeout", on_timeout)
		add_child(timer)

# Prevent player from taking possession of ball immediately after passing
func pass_cooldown():
	is_on_pass_cooldown = false

func shoot_ball():
	if !is_stunned:
		var ball = game.ball
		# Face toward opponent goal
		curr_direction = Direction.LEFT if side == Side.CPU else Direction.RIGHT
		var x_diff = -BALL_DRIBBLE_GAP if curr_direction == Direction.LEFT else BALL_DRIBBLE_GAP
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y)

		# Shoot ball toward goal
		var opp_goal = get_opposing_goal()
		var dir = (opp_goal.global_position - ball.global_position).normalized()
		var velocity_vector = dir * SHOOT_SPEED
		ball.curr_poss_status = Ball.POSS_STATUS.SHOT_ON_CPU_GOAL if side == Side.PLAYER else Ball.POSS_STATUS.SHOT_ON_PLAYER_GOAL
		ball.metadata["shot_force"] = shot_force
		ball.linear_velocity = velocity_vector
		lose_poss_of_ball()

func handle_ball_collision():
	var ball = game.ball as Ball
	if !is_on_pass_cooldown and ball.is_loose():
		take_poss_of_ball()
	
func get_self_goal():
	return game.cpu_goal if side == Side.CPU else game.player_goal

func get_opposing_goal():
	return game.cpu_goal if side == Side.PLAYER else game.player_goal

func get_opposing_field_players():
	return game.cpu_manager.field_players if side == Side.PLAYER else game.player_manager.field_players

func on_completed_pass():
	is_on_pass_cooldown = true
	pass_target = null

func take_poss_of_ball():
	var ball = game.ball as Ball
	ball.linear_velocity = Vector2.ZERO
	ball.curr_poss_status = Ball.POSS_STATUS.PLAYER if side == Side.PLAYER else Ball.POSS_STATUS.CPU
	var curr_ball_handler = game.get_ball_handler()
	if curr_ball_handler != null and curr_ball_handler != self:
		curr_ball_handler.lose_poss_of_ball()
	has_possession = true

func lose_poss_of_ball():
	has_possession = false

func side_has_possession():
	for p in field_manager.field_players:
		if p.has_possession:
			return true
	return false

func move_to_position(dest_position: Vector2, is_at_pos_threshold):
	if is_going_for_steal:
		return
	if global_position.distance_to(dest_position) <= is_at_pos_threshold or is_stunned:
		is_moving_to_position = false
		linear_velocity = Vector2.ZERO
	else:
		is_moving_to_position = true
		context_map.target_position = dest_position
		var dir = context_map.best_dir
		var desired_velocity = dir * FieldPlayer.SPEED
		var steering_force = desired_velocity - linear_velocity
		linear_velocity = linear_velocity + (steering_force * 2 * 0.0167)

func move_in_direction(dir: Vector2):
	linear_velocity = dir.normalized() * FieldPlayer.SPEED

func has_open_shot():
	return !ray_to_goal.is_colliding()

func get_open_pass_targets():
	var open_pass_targets = []
	for ray_mapping in ray_to_allies:
		var raycast = ray_mapping["raycast"] as RayCast2D
		if !raycast.is_colliding():
			open_pass_targets.append(ray_mapping["player_ref"])
	return open_pass_targets

func get_closest_enemy_field_player():
	var opp_field_manager = game.player_manager if side == Side.CPU else game.cpu_manager
	var closest_field_player = null
	var closest_dist = INF
	for p in opp_field_manager.field_players:
		var dist_to_player = global_position.distance_to(p.global_position)
		if dist_to_player < closest_dist:
			closest_field_player = p
			closest_dist = dist_to_player
	return closest_field_player

func stun():
	is_stunned = true
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = DEFAULT_STUN_SECONDS
	timer.one_shot = true
	var on_timeout = Callable(self, "stun_wear_off")
	timer.connect("timeout", on_timeout)
	add_child(timer)
	modulate = Color(1.0, 1.0, 0, 0.8)

func stun_wear_off():
	modulate = Color(1.0, 1.0, 1.0, 1)
	is_stunned = false

func on_steal_hitbox_collided(body: Node2D):
	if body is FieldPlayer:
		var field_player = body as FieldPlayer
		if field_player.side != side and is_going_for_steal:
			var prev_ball_handler = game.get_ball_handler()
			if prev_ball_handler != null:
				prev_ball_handler.stun()
			game.camera.apply_shake()
			take_poss_of_ball()

func steal_ball():
	var ball_handler = game.get_ball_handler()
	print(player_name + " going for steal on " + ball_handler.player_name)
	if ball_handler != null:
		is_going_for_steal = true
		steal_direction = (ball_handler.global_position - global_position).normalized()
		linear_damp = 5
		apply_impulse(steal_direction * 1000)

		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = 0.5
		var on_timeout = Callable(self, "steal_finished")
		timer.connect("timeout", on_timeout)
		add_child(timer)

func steal_finished():
	linear_damp = 0
	is_going_for_steal = false


func can_steal():
	var ball_handler = game.get_ball_handler()
	if ball_handler != null:
		var dist_to_ball_handler = global_position.distance_to(ball_handler.global_position)
		return dist_to_ball_handler <= FieldPlayer.STEAL_RANGE and !is_going_for_steal and !is_stunned
	else:
		return false