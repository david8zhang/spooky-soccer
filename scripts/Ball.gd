class_name Ball
extends RigidBody2D

enum POSS_STATUS {
	PLAYER,
	CPU,
	PLAYER_PASS,
	CPU_PASS,
	SHOT_ON_PLAYER_GOAL,
	SHOT_ON_CPU_GOAL,
	LOOSE
}

@onready var collision_detector = $CollisionDetector/CollisionShape2D
@onready var status_label = $Label

func disable_collision_detector():
	collision_detector.set_deferred("disabled", true)

func enable_collision_detector():
	collision_detector.set_deferred("disabled", false)

var curr_poss_status

# Metadata stored on the ball
var metadata = {}

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for name_key in enum_dict.keys():
		if enum_dict[name_key] == value:
				return name_key
	return "Unknown"

func _physics_process(_delta):
	var viewport = get_viewport_rect()
	var min_x = -viewport.size.x / 2
	var max_x = viewport.size.x / 2
	var min_y = -viewport.size.y / 2
	var max_y = viewport.size.y / 2
	global_position = Vector2(clamp(global_position.x, min_x, max_x), clamp(global_position.y, min_y, max_y))

func place_ball_in_front(curr_player: FieldPlayer, direction):
	var viewport = get_viewport_rect()
	var min_x = -viewport.size.x / 2
	var max_x = viewport.size.x / 2
	var min_y = -viewport.size.y / 2
	var max_y = viewport.size.y / 2
	var x_diff = -FieldPlayer.BALL_DRIBBLE_GAP if direction == FieldPlayer.Direction.LEFT else FieldPlayer.BALL_DRIBBLE_GAP
	var x_pos = clamp(curr_player.global_position.x + x_diff, min_x, max_x)
	var y_pos = clamp(curr_player.global_position.y + 20, min_y, max_y)
	global_position = Vector2(x_pos, y_pos)

func _process(_delta):
	status_label.text = get_enum_name(POSS_STATUS, curr_poss_status)

func _on_field_player_detector_body_entered(body):
	if body is FieldPlayer:
		var field_player = body as FieldPlayer
		field_player.handle_ball_collision()
	if body is Goal:
		var goal = body as Goal
		goal.handle_ball_collision(self)

func is_loose():
	return curr_poss_status == POSS_STATUS.SHOT_ON_CPU_GOAL or \
		curr_poss_status == POSS_STATUS.SHOT_ON_PLAYER_GOAL or \
		curr_poss_status == POSS_STATUS.LOOSE