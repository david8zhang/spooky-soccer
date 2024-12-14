class_name ShouldGoForSteal
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var defensive_behavior = blackboard.get_value("defensive_behavior")
	var is_steal_behavior = defensive_behavior["behavior_type"] == AssignDefensiveBehavior.DefensiveBehaviors.GO_FOR_STEAL
	var is_able_to_steal = field_player.is_able_to_steal()
	return SUCCESS if is_steal_behavior and is_able_to_steal else FAILURE