class_name InitPlayerBlackboard
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	blackboard.set_value("game", field_player.game)
	return SUCCESS