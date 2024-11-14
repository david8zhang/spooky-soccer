class_name IsNotPlayerControlled
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as PlayerFieldPlayer
	var player_manager = field_player.field_manager as PlayerFieldManager
	return SUCCESS if player_manager.selected_player != field_player else FAILURE