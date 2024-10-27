class_name PlayerFieldManager
extends FieldManager

var player_configs = [
	{
		"position": Vector2(-300, -100),
		"name": "Player 1"
	},
	{
		"position": Vector2(-300, 100),
		"name": "Player 2"
	}
]

var goalkeeper_config = {
	"position": Vector2(-475, 0),
	"name": "Player GK"
}

func _ready():
	init_players(player_configs, FieldPlayer.Side.PLAYER)
	init_goalkeeper(goalkeeper_config, FieldPlayer.Side.PLAYER)
	field_players[0].is_selected = true
