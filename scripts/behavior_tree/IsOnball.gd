class_name IsOnball
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	return SUCCESS if field_player.has_possession else FAILURE