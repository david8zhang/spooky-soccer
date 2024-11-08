class_name AssignDefensiveBehavior
extends ActionLeaf

enum DefensiveBehaviors {
	GO_FOR_STEAL,
	MOVE_TO_DEF_POSITION
}

var DEF_BEHAVIOR_TTL_MS = 10000

func tick(_actor: Node, blackboard: Blackboard):
	var existing_defensive_behavior = blackboard.get_value("defensive_behavior")
	var curr_timestamp = Time.get_unix_time_from_system() * 1000
	if existing_defensive_behavior == null or curr_timestamp - existing_defensive_behavior["timestamp"] >= DEF_BEHAVIOR_TTL_MS:
		var random_def_behavior_type = DefensiveBehaviors.GO_FOR_STEAL if randi_range(0, 1) == 1 else DefensiveBehaviors.MOVE_TO_DEF_POSITION
		blackboard.set_value("defensive_behavior", {
			"behavior_type": random_def_behavior_type,
			"timestamp": curr_timestamp
		})
	return SUCCESS