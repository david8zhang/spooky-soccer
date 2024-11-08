class_name ChaseBallHandler
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	var ball_handler = game.get_ball_handler()
	var field_player = actor as FieldPlayer
	field_player.move_to_position(ball_handler.global_position, 5)
	return SUCCESS