class_name IsInDanger
extends ConditionLeaf

static var DANGER_THRESHOLD = 100

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var closest_enemy_player = field_player.get_closest_enemy_field_player()
	var dist_to_enemy = field_player.global_position.distance_to(closest_enemy_player.global_position)

	# Prevent retreat when enemy is going for steal (so that enemy can't immediately act out of steal)
	return SUCCESS if dist_to_enemy <= DANGER_THRESHOLD and !field_player.is_going_for_steal else FAILURE
