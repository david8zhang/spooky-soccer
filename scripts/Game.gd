class_name Game
extends Node2D

@onready var player_manager: PlayerFieldManager = $PlayerFieldManager
@onready var cpu_manager: CPUFieldManager = $CPUFieldManager
@onready var ball = $Ball
@onready var player_goal = $LeftGoal
@onready var cpu_goal = $RightGoal
@onready var scoreboard: Label = get_node("/root/Main/CanvasLayer/Scoreboard")
@onready var cpu_offensive_zones = $CPUOffensiveZones as Zones
@onready var cpu_offensive_support_zones = $CPUOffensiveSupportZones as Zones
@onready var player_offensive_zones = $PlayerOffensiveSupportZones as Zones
@onready var camera = $Camera2D as Camera

var cpu_score = 0
var player_score = 0
var just_scored = false

signal all_ready

func _ready():
	var player = player_manager.field_players[0] as FieldPlayer
	player.take_poss_of_ball()
	all_ready.emit()

func on_cpu_scored():
	cpu_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)

func on_player_scored():
	player_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)

func reset_after_score(last_scored_side: FieldPlayer.Side):
	just_scored = false
	cpu_manager.reset_after_score(last_scored_side)
	player_manager.reset_after_score(last_scored_side)

func get_ball_handler():
	for pfp in player_manager.field_players:
		if pfp.has_possession:
			return pfp
	for cfp in cpu_manager.field_players:
		if cfp.has_possession:
			return cfp
	return null
