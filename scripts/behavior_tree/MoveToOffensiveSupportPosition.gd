class_name MoveToOffensiveSupportPosition
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var open_position_map = blackboard.get_value("curr_offball_pos")
	var field_player = actor as FieldPlayer
	field_player.move_to_position(open_position_map["position"], 5)
	return SUCCESS
