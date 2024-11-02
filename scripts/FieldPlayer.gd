class_name FieldPlayer
extends RigidBody2D

const SPEED = 250
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
@onready var context_map = $ContextMap as ContextMap
@onready var ray_to_goal = $RayToGoal as RayCast2D
@onready var ray_to_allies = []

var field_manager: FieldManager

func _ready():
	game.all_ready.connect(all_ready)

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
	update_ray_collision_based_on_side(ray_to_goal)
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
		var x_diff = -50 if curr_direction == Direction.LEFT else 50
		ball.global_position = Vector2(global_position.x + x_diff, global_position.y)

	# For checking if the player currently has an open shot on offense
	if ray_to_goal != null:
		ray_to_goal.target_position = ray_to_goal.to_local(get_opposing_goal().global_position)
	update_ray_to_ally_mappings()

func pass_ball():
	if pass_target != null:
		can_take_possession = false
		var ball = game.ball as Ball
		var dir = (pass_target.global_position - ball.global_position).normalized()
		var velocity_vector = dir * PASS_SPEED
		ball.linear_velocity = velocity_vector
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER_PASS if side == Side.PLAYER else Ball.POSS_STATUS.CPU_PASS
		ball.metadata["prev_possessor"] = self
		ball.enable_collision_detector()
		is_selected = false
		lose_poss_of_ball()

func shoot_ball():
	var ball = game.ball
	# Face toward opponent goal
	curr_direction = Direction.LEFT if side == Side.CPU else Direction.RIGHT
	var x_diff = -50 if curr_direction == Direction.LEFT else 50
	ball.global_position = Vector2(global_position.x + x_diff, global_position.y)

	# Shoot ball toward goal
	var opp_goal = get_opposing_goal()
	var dir = (opp_goal.global_position - ball.global_position).normalized()
	var velocity_vector = dir * SHOOT_SPEED
	ball.curr_poss_status = Ball.POSS_STATUS.SHOT_ON_CPU_GOAL
	ball.metadata["shot_force"] = shot_force
	ball.enable_collision_detector()
	ball.linear_velocity = velocity_vector
	lose_poss_of_ball()

func handle_ball_collision():
	var ball = game.ball as Ball
	if can_take_possession:
		if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER_PASS or ball.curr_poss_status == Ball.POSS_STATUS.CPU_PASS:
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
	ball.linear_velocity = Vector2.ZERO
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
		context_map.target_position = dest_position
		var dir = context_map.best_dir
		var desired_velocity = dir * FieldPlayer.SPEED
		var steering_force = desired_velocity - linear_velocity
		linear_velocity = linear_velocity + (steering_force * 2 * 0.0167)

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
