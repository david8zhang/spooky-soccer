class_name MoveToOpenPosition
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var target_position = blackboard.get_value("OFFBALL_OFFENSE_TARGET_POSITION")
	var field_player = actor as FieldPlayer
	if target_position == null:
		var opp_goal = field_player.get_opposing_goal()
		var rand_angle = deg_to_rad(randi_range(-75, 75))
		target_position = Vector2(opp_goal.global_position.x, 0) + Vector2(250, 0).rotated(rand_angle)
		blackboard.set_value("OFFBALL_OFFENSE_TARGET_POSITION", target_position)
	field_player.move_to_position(target_position, 5)
	return SUCCESS
