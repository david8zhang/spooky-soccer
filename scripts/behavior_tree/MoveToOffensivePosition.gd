class_name MoveToOffensivePosition
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var open_position_map = blackboard.get_value("curr_onball_pos")
	var field_player = actor as FieldPlayer
	field_player.move_to_position(open_position_map["position"], 5)
	return SUCCESS