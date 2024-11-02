class_name SaveOpenPassTarget
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var pass_targets = field_player.get_open_pass_targets()
	for p in pass_targets:
		var pass_target = p as FieldPlayer
		if pass_target.has_open_shot():
			blackboard.set_value("open_pass_target", pass_target)
			return SUCCESS
	blackboard.set_value("open_pass_target", null)
	return FAILURE