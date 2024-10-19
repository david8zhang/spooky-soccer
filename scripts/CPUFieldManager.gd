class_name CPUFieldManager
extends FieldManager

var player_configs = [
	{
		"position": Vector2(300, -100)
	},
	{
		"position": Vector2(300, 100)
	}
]

var goalkeeper_config = {
	"position": Vector2(500, 0)
}

func _ready():
	init_players(player_configs)
	init_goalkeeper(goalkeeper_config)
