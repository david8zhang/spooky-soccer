class_name StealBall
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	field_player.steal_ball()
	return SUCCESS