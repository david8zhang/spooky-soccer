class_name NearOpponentGoal
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var opp_goal = field_player.get_opposing_goal() as Goal
	var dist_to_opp_goal = field_player.global_position.distance_to(opp_goal.global_position)
	var dist_to_goal_threshold = blackboard.get_value("goal_dist_threshold")
	return SUCCESS if dist_to_opp_goal <= dist_to_goal_threshold else FAILURE