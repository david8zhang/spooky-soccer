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

var selected_player

func _ready():
	init_players(player_configs, FieldPlayer.Side.PLAYER)
	init_goalkeeper(goalkeeper_config, FieldPlayer.Side.PLAYER)
	field_players[0].is_selected = true

func select_new_player(field_player: FieldPlayer):
	if selected_player != null and selected_player != field_player:
		selected_player.is_selected = false
	field_player.is_selected = true
	selected_player = field_player