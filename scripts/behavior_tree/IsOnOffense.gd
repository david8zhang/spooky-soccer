class_name IsOnOffense
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	return SUCCESS if field_player.side_has_possession() else FAILURE