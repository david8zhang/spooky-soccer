class_name Game
extends Node2D

@onready var player_manager: PlayerFieldManager = $PlayerFieldManager
@onready var ball = $Ball
@onready var player_goal = $LeftGoal
@onready var cpu_goal = $RightGoal

func _ready():
	var player = player_manager.field_players[0] as FieldPlayer
	player.take_poss_of_ball()
