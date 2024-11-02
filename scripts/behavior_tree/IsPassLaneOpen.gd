class_name IsPassLaneOpen
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var open_pass_targets = field_player.get_open_pass_targets()
	return SUCCESS if open_pass_targets.size() > 0 else FAILURE