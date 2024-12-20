class_name Game
extends Node2D

@onready var player_manager: PlayerFieldManager = $PlayerFieldManager
@onready var cpu_manager: CPUFieldManager = $CPUFieldManager
@onready var ball = $Ball
@onready var player_goal = $LeftGoal
@onready var cpu_goal = $RightGoal
@onready var scoreboard: Label = $CanvasLayer/Scoreboard as Label
@onready var cpu_offensive_zones = $CPUOffensiveZones as Zones
@onready var cpu_offensive_support_zones = $CPUOffensiveSupportZones as Zones
@onready var player_offensive_zones = $PlayerOffensiveSupportZones as Zones
@onready var camera = $Camera2D as Camera
@onready var match_timer = $CanvasLayer/MatchTimer as MatchTimer

var cpu_score = 0
var player_score = 1
var just_scored = false
var is_overtime = false

signal all_ready

func _ready():
	var player = player_manager.field_players[0] as FieldPlayer
	player.take_poss_of_ball()
	all_ready.emit()
	match_timer.on_match_timer_expired.connect(on_match_timer_expired)

func on_match_timer_expired():
	if cpu_score == player_score:
		is_overtime = true
	else:
		process_winner()

func process_winner():
	if player_score > cpu_score:
		get_tree().change_scene_to_file("res://scenes/PowerUpSelect.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func on_cpu_scored():
	cpu_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)
	if is_overtime:
		process_winner()

func on_player_scored():
	player_score += 1
	scoreboard.text = str(player_score) + "-" + str(cpu_score)
	if is_overtime:
		process_winner()

func reset_after_score(last_scored_side: FieldPlayer.Side):
	# If we're in overtime, go to the victory / defeat screen
	if !is_overtime:
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

static func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for name_key in enum_dict.keys():
		if enum_dict[name_key] == value:
				return name_key
	return "Unknown"