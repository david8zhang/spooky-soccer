class_name IsWithinStealRange
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	return SUCCESS if field_player.is_within_steal_range() else FAILURE