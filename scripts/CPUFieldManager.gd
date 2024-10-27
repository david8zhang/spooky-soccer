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
