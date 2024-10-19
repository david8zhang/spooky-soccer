class_name FieldManager
extends Node

@export var player_scene: PackedScene
@export var goalkeeper_scene: PackedScene
var field_players = []
var goalkeeper

func init_players(player_configs):
	for config in player_configs:
		var new_field_player = player_scene.instantiate() as FieldPlayer
		new_field_player.global_position = config["position"]
		new_field_player.field_manager = self
		field_players.append(new_field_player)
		add_child(new_field_player)

func init_goalkeeper(goalkeeper_config):
	goalkeeper = goalkeeper_scene.instantiate() as Goalkeeper
	goalkeeper.global_position = goalkeeper_config["position"]
	goalkeeper.field_manager = self
	add_child(goalkeeper)
