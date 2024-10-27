class_name Idle
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	field_player.linear_velocity = Vector2.ZERO
	return SUCCESS