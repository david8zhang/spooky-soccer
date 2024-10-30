class_name ShootBall
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	field_player.shoot_ball()