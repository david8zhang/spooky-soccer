class_name FieldManager
extends Node

@export var player_scene: PackedScene
@export var goalkeeper_scene: PackedScene
@onready var game = get_node("/root/Main") as Game

var field_players = []
var defensive_assignments = {}
var goalkeeper

func init_players(player_configs, side: FieldPlayer.Side):
	for config in player_configs:
		var new_field_player = player_scene.instantiate() as FieldPlayer
		new_field_player.global_position = config["position"]
		new_field_player.player_name = config["name"]
		new_field_player.side = side
		new_field_player.field_manager = self
		field_players.append(new_field_player)
		add_child(new_field_player)

func init_goalkeeper(goalkeeper_config, side: FieldPlayer.Side):
	goalkeeper = goalkeeper_scene.instantiate() as Goalkeeper
	goalkeeper.global_position = goalkeeper_config["position"]
	goalkeeper.player_name = goalkeeper_config["name"]
	goalkeeper.side = side
	goalkeeper.field_manager = self
	add_child(goalkeeper)

func get_offensive_zones():
	pass

func get_offensive_support_zones():
	pass

func get_defensive_zones():
	pass

func get_opposing_manager():
	pass

func get_default_position(_player_name):
	pass

func reset_after_score(_last_scored_side):
	for player in field_players:
		player.global_position = get_default_position(player.player_name)
	goalkeeper.save_meter.value = 100

func assign_defenders():
	var opp_players = get_opposing_manager().field_players
	var opp_player_names = opp_players.map(func(player: FieldPlayer): return player.player_name)
	opp_player_names.shuffle()
	for i in range(0, opp_player_names.size()):
		var player = field_players[i]
		defensive_assignments[player.player_name] = opp_player_names[i]

func get_player_to_defend(player_name: String):
	if defensive_assignments.has(player_name):
		var opp_player_name = defensive_assignments[player_name]
		var opp_players = get_opposing_manager().field_players
		for p in opp_players:
			if p.player_name == opp_player_name:
				return p
		return null
	else:
		return null
