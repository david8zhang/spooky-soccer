class_name IsInStealRange
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	var field_player = actor as FieldPlayer
	var ball_handler = game.get_ball_handler()
	return SUCCESS if field_player.global_position.distance_to(ball_handler.global_position) <= FieldPlayer.STEAL_RANGE else FAILURE