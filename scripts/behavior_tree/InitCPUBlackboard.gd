class_name InitCPUBlackboard
extends ActionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	blackboard.set_value("goal_dist_threshold", 200)
	return SUCCESS