class_name IsOpen
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	return SUCCESS if field_player.has_open_shot() else FAILURE