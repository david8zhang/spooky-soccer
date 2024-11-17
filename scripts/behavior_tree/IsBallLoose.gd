class_name IsBallLoose
extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	var ball = game.ball
	return SUCCESS if ball.is_loose() else FAILURE