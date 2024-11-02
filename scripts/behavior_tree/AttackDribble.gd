class_name AttackDribble
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var target_pos = field_player.get_opposing_goal().global_position
	field_player.move_to_position(target_pos, 5)
	return SUCCESS