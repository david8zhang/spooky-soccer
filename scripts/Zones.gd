class_name Zones
extends Node

var zone_markers = []

func _ready():
	for zone_marker in get_children():
		zone_markers.append(zone_marker)

func pick_random():
	return zone_markers.pick_random()