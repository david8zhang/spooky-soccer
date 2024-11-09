class_name MoveToDefensivePosition
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var manager = field_player.field_manager as FieldManager
	var player_to_defend = manager.get_player_to_defend(field_player.player_name)
	var self_goal = field_player.get_self_goal()
	var def_position = Vector2(
		(self_goal.global_position.x + player_to_defend.global_position.x) / 2,
		(self_goal.global_position.y + player_to_defend.global_position.y) / 2
	)
	field_player.move_to_position(def_position, 5)
	return SUCCESS
