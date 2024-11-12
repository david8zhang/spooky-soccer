class_name ChaseLooseBall
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var game = blackboard.get_value("game") as Game
	var field_player = actor as FieldPlayer
	var ball = game.ball as Ball
	field_player.move_to_position(ball.global_position, 5)
	return SUCCESS