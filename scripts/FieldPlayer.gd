class_name FieldPlayer
extends CharacterBody2D

const SPEED = 300.0
var is_selected = false

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

		move_and_slide()
