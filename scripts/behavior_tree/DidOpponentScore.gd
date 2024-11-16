class_name DidOpponentScore
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var game = blackboard.get_value("game") as Game
	if field_player.side == FieldPlayer.Side.CPU:
		var goal = game.cpu_goal
		return SUCCESS if goal.side_just_scored == FieldPlayer.Side.PLAYER else FAILURE
	else:
		var goal = game.player_goal
		return SUCCESS if goal.side_just_scored == FieldPlayer.Side.CPU else FAILURE
