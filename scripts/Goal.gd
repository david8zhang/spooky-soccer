class_name Goal
extends StaticBody2D

func handle_ball_collision(ball: Ball):
	ball.linear_velocity = Vector2.ZERO
	print("Scored!")
