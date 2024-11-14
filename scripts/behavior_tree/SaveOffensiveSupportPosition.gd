class_name SaveOffensiveSupportPosition
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var field_player = actor as FieldPlayer
	var field_manager = field_player.field_manager as FieldManager
	var zones = field_manager.get_offensive_support_zones() as Zones
	var prev_offball_pos = blackboard.get_value("curr_offball_pos")
	var best_zone = pick_best_zone_from_zones(zones, prev_offball_pos)
	var curr_timestamp = Time.get_unix_time_from_system() * 1000
	blackboard.set_value("curr_offball_pos", {
		"position": best_zone.global_position,
		"timestamp": curr_timestamp,
		"zone": best_zone.name
	})
	return SUCCESS

func pick_best_zone_from_zones(zones: Zones, prev_pos_data):
	var valid_zone_markers = []

	# Prevent going to the same zone as before
	if prev_pos_data != null:
		var prev_zone_name = prev_pos_data["zone"]
		for zone_marker in zones.zone_markers:
			if zone_marker.name != prev_zone_name:
				valid_zone_markers.append(zone_marker)
	else:
		valid_zone_markers = zones.zone_markers

	# Pick a random zone to go to
	return valid_zone_markers.pick_random()
