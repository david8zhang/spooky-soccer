class_name Goal
extends StaticBody2D

@onready var game = get_node("/root/Main") as Game
@export var side: FieldPlayer.Side
var side_just_scored

func handle_ball_collision(ball: Ball):
	ball.linear_velocity = Vector2.ZERO
	ball.hide()

	side_just_scored = FieldPlayer.Side.PLAYER
	if side == FieldPlayer.Side.PLAYER:
		game.on_cpu_scored()
		side_just_scored = FieldPlayer.Side.CPU
	elif side == FieldPlayer.Side.CPU:
		game.on_player_scored()
		side_just_scored = FieldPlayer.Side.PLAYER

	var reset_timer = Timer.new()
	reset_timer.wait_time = 2
	reset_timer.autostart = true
	reset_timer.one_shot = true
	var callable = Callable(self, "reset_after_score")
	reset_timer.connect("timeout", callable)
	add_child(reset_timer)

func reset_after_score():
	game.reset_after_score(side_just_scored)
	side_just_scored = null
