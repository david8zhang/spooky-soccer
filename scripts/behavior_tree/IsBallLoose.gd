class_name IsBallLoose
extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	var ball = game.ball
	return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.LOOSE else FAILURE