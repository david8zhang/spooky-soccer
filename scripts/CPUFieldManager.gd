class_name CPUFieldManager
extends FieldManager

var player_configs = [
	{
		"position": Vector2(300, -100),
		"name": "CPU Player 1"
	},
	{
		"position": Vector2(300, 100),
		"name": "CPU Player 2"
	}
]

var goalkeeper_config = {
	"position": Vector2(475, 0),
	"name": "CPU GK"
}

func _ready():
	init_players(player_configs, FieldPlayer.Side.CPU)
	init_goalkeeper(goalkeeper_config, FieldPlayer.Side.CPU)
	game.all_ready.connect(all_ready)

func get_offensive_zones():
	return self.game.cpu_offensive_zones

func get_offensive_support_zones():
	return self.game.cpu_offensive_support_zones

func get_opposing_manager():
	return game.player_manager

func all_ready():
	super.assign_defenders()

func get_default_position(player_name):
	for config in player_configs:
		if config.name == player_name:
			return config.position
	return null