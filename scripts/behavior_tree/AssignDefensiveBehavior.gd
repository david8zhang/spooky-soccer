class_name AssignDefensiveBehavior
extends ActionLeaf

enum DefensiveBehaviors {
	GO_FOR_STEAL,
	MOVE_TO_DEF_POSITION
}

var DEF_BEHAVIOR_TTL_MS = 10000

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var existing_defensive_behavior = blackboard.get_value("defensive_behavior")
	var curr_timestamp = Time.get_unix_time_from_system() * 1000
	var game = blackboard.get_value("game") as Game
	var ball_handler = game.get_ball_handler()
	if ball_handler == null:
		return FAILURE
	var distance_to_ball_handler = field_player.global_position.distance_to(ball_handler.global_position)
	# Don't go for a steal unless within a distance range
	if distance_to_ball_handler > 300:
		blackboard.set_value("defensive_behavior", {
			"behavior_type": DefensiveBehaviors.MOVE_TO_DEF_POSITION,
			"timestamp": curr_timestamp
		})
	else:
		if existing_defensive_behavior == null or curr_timestamp - existing_defensive_behavior["timestamp"] >= DEF_BEHAVIOR_TTL_MS:
			var random_def_behavior_type = DefensiveBehaviors.GO_FOR_STEAL if randi_range(0, 1) == 1 else DefensiveBehaviors.MOVE_TO_DEF_POSITION
			blackboard.set_value("defensive_behavior", {
				"behavior_type": random_def_behavior_type,
				"timestamp": curr_timestamp
			})
	return SUCCESS
