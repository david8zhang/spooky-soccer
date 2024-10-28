class_name AttackDribble
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var target_pos = blackboard.get_value("ATTACK_DRIBBLE_TARGET_POS")
	if target_pos == null:
		target_pos = get_target_pos()
		blackboard.set_value("ATTACK_DRIBBLE_TARGET_POS", target_pos)
	field_player.move_to_position(target_pos, 5)
	return SUCCESS
	

func get_target_pos() -> Vector2:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var window_size = get_viewport().get_visible_rect().size
	var random_y = random.randi_range(-window_size.y / 2 + 5, window_size.y / 2 - 5)
	var x = -window_size.x / 2 + 400
	# return Vector2(x, random_y)
	return Vector2(-350, 100)