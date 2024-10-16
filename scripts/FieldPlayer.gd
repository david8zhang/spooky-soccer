class_name FieldPlayer
extends CharacterBody2D

const SPEED = 300.0
var is_selected = false
var has_possession = false

@onready var game = get_node("/root/Main") as Game
var field_manager

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if is_selected:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED

		if has_possession:
			var ball = game.ball as RigidBody2D
			ball.global_position = Vector2(global_position.x + 50, global_position.y)
		move_and_slide()

func take_poss_of_ball():
	has_possession = true

func lose_poss_of_ball():
	has_possession = false
