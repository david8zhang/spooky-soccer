class_name Game
extends Node2D

@onready var player_manager: PlayerFieldManager = $PlayerFieldManager
@onready var cpu_manager: CPUFieldManager = $CPUFieldManager
@onready var ball = $Ball
@onready var player_goal = $LeftGoal
@onready var cpu_goal = $RightGoal
@onready var scoreboard: Label = get_node("/root/Main/CanvasLayer/Scoreboard")

var cpu_score = 0
var player_score = 0

func _ready():
	var player = player_manager.field_players[0] as FieldPlayer
	player.take_poss_of_ball()

func on_cpu_scored():
	cpu_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)

func on_player_scored():
	player_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)


func reset_after_score(last_scored_side: FieldPlayer.Side):
	if last_scored_side == FieldPlayer.Side.PLAYER:
		var cpu_player = cpu_manager.field_players[0] as FieldPlayer
		cpu_player.take_poss_of_ball()
	elif last_scored_side == FieldPlayer.Side.CPU:
		var player = player_manager.field_players[0] as FieldPlayer
		player.take_poss_of_ball()