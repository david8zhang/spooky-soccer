class_name IsAtPositionForTooLong
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var curr_onball_pos = blackboard.get_value("curr_onball_pos") if field_player.has_possession else blackboard.get_value("curr_offball_pos")
	if curr_onball_pos == null:
		return SUCCESS
	if field_player.is_moving_to_position:
		return FAILURE
	var position = curr_onball_pos["position"]
	var dist = field_player.global_position.distance_to(position)
	if dist <= 5:
		var timestamp = curr_onball_pos["timestamp"]
		var curr_timestamp = Time.get_unix_time_from_system() * 1000
		randomize()
		var random_ttl = randi_range(1000, 3000)
		return SUCCESS if curr_timestamp - timestamp >= random_ttl else FAILURE
	return FAILURE
