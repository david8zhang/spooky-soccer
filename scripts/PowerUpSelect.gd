class_name PowerUpSelect
extends Node2D

@onready var button = $CanvasLayer/Button as Button

# Called when the node enters the scene tree for the first time.
func _ready():
	button.pressed.connect(start_next_round)

func start_next_round():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
