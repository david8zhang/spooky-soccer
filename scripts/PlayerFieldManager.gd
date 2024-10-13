class_name PlayerFieldManager
extends Node2D

@export var player_scene: PackedScene
var field_players = []
var goalkeeper

var player_configs = [
	{
		"position": Vector2(-400, -100)
	},
	{
		"position": Vector2(-400, 100)
	}
]

func _ready():
	for config in player_configs:
		var new_field_player = player_scene.instantiate() as FieldPlayer
		new_field_player.global_position = config["position"]
		field_players.append(new_field_player)
		add_child(new_field_player)
	field_players[0].is_selected = true
