class_name MatchTimer
extends Label

@onready var game = get_node("/root/Main") as Game

var match_timer
const MATCH_TIME_SECONDS = 180

signal on_match_timer_expired

func _ready():
	match_timer = Timer.new()
	match_timer.wait_time = MATCH_TIME_SECONDS
	match_timer.autostart = true
	match_timer.one_shot = true
	var callable = Callable(self, "match_timer_expired")
	match_timer.timeout.connect(callable)
	add_child(match_timer)

func match_timer_expired():
	on_match_timer_expired.emit()

func _process(_delta):
	if game.is_overtime:
		text = "Overtime!"
	else:
		text = convert_seconds_to_minutes_and_seconds(int(match_timer.time_left))

func convert_seconds_to_minutes_and_seconds(total_seconds: int) -> String:
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return str(minutes) + ":" + "%02d" % seconds
