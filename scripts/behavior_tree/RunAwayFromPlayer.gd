class_name RunAwayFromPlayer
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var closest_enemy_player = field_player.get_closest_enemy_field_player()
	var dir_to_player = closest_enemy_player.global_position - field_player.global_position
	field_player.move_in_direction(-dir_to_player)
	return SUCCESS