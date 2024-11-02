class_name IsTeamMateOpen
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var pass_targets = field_player.get_open_pass_targets()
	for p in pass_targets:
		var pass_target = p as FieldPlayer
		if pass_target.has_open_shot():
			return SUCCESS
	return FAILURE