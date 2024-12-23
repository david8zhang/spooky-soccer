class_name SaveOpenPassTarget
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var pass_targets = field_player.get_open_pass_targets()
	for p in pass_targets:
		var pass_target = p as FieldPlayer
		if pass_target.has_open_shot() and is_near_opp_goal(pass_target, blackboard):
			blackboard.set_value("open_pass_target", pass_target)
			return SUCCESS
	blackboard.set_value("open_pass_target", null)
	return FAILURE

func is_near_opp_goal(pass_target: FieldPlayer, blackboard: Blackboard):
	var opp_goal = pass_target.get_opposing_goal()
	var dist_to_goal = pass_target.global_position.distance_to(opp_goal.global_position)
	var dist_to_goal_threshold = blackboard.get_value("goal_dist_threshold")
	return dist_to_goal <= dist_to_goal_threshold