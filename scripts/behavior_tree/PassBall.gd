class_name PassBall
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var open_pass_target = blackboard.get_value("open_pass_target") as FieldPlayer
	var field_player = actor as FieldPlayer
	if open_pass_target != null:
		field_player.pass_target = open_pass_target
		field_player.pass_ball()
		return SUCCESS
	var open_pass_targets = field_player.get_open_pass_targets()
	if open_pass_targets.size() > 0:
		field_player.pass_target = open_pass_targets[0]
		field_player.pass_ball()
		return SUCCESS
	return FAILURE