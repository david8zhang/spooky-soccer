class_name JustScored
extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	return SUCCESS if game.just_scored else FAILURE