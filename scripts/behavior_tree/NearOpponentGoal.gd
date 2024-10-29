class_name NearOpponentGoal
extends ConditionLeaf

var DIST_THRESHOLD = 350

func tick(actor: Node, _blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var opp_goal = field_player.get_opposing_goal() as Goal
	var dist_to_opp_goal = field_player.global_position.distance_to(opp_goal.global_position)
	return SUCCESS if dist_to_opp_goal <= DIST_THRESHOLD else FAILURE