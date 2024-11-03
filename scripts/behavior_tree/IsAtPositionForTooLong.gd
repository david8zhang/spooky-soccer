class_name IsAtPositionForTooLong
extends ConditionLeaf

static var TTL = 2500

func tick(actor: Node, blackboard: Blackboard):
	var curr_onball_pos = blackboard.get_value("curr_onball_pos")
	if curr_onball_pos == null:
		return SUCCESS
	var field_player = actor as FieldPlayer
	var position = curr_onball_pos["position"]
	var dist = field_player.global_position.distance_to(position)
	if dist <= 5:
		var timestamp = curr_onball_pos["timestamp"]
		var curr_timestamp = Time.get_unix_time_from_system() * 1000
		return SUCCESS if curr_timestamp - timestamp >= TTL else FAILURE
	return FAILURE
