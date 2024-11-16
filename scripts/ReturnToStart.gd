class_name ReturnToStart
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var manager = field_player.field_manager as FieldManager
	var default_position = manager.get_default_position(field_player.player_name)
	field_player.move_to_position(default_position, 5)
	return SUCCESS