class_name CanStealBall
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	return SUCCESS if field_player.can_steal() else FAILURE
