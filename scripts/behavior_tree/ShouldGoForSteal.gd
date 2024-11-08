class_name ShouldGoForSteal
extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	var defensive_behavior = blackboard.get_value("defensive_behavior")
	return SUCCESS if \
		defensive_behavior["behavior_type"] == AssignDefensiveBehavior.DefensiveBehaviors.GO_FOR_STEAL else FAILURE