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
	game.all_ready.connect(all_ready)

func select_new_player(field_player: FieldPlayer):
	if selected_player != null and selected_player != field_player:
		selected_player.lose_poss_of_ball()
	selected_player = field_player

func all_ready():
	super.assign_defenders()

func get_opposing_manager():
	return game.cpu_manager

func get_offensive_support_zones():
	return self.game.player_offensive_zones

func get_default_position(player_name):
	for config in player_configs:
		if config.name == player_name:
			return config.position
	return null

func reset_after_score(last_scored_side):
	super.reset_after_score(last_scored_side)
	if last_scored_side != FieldPlayer.Side.PLAYER:
		field_players[0].take_poss_of_ball()
