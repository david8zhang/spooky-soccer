class_name SaveOffensivePosition
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var field_manager = field_player.field_manager as FieldManager
	var zones = field_manager.get_offensive_zones() as Zones
	var random_zone = zones.pick_random()
	var curr_timestamp = Time.get_unix_time_from_system() * 1000
	blackboard.set_value("curr_onball_pos", {
		"position": random_zone.global_position,
		"timestamp": curr_timestamp
	})
	return SUCCESS
