class_name Goalkeeper
extends FieldPlayer

# Goalkeeper can save the ball if their "save meter" is still full
# Ever save depletes the save meter, and once empty, the next shot is guaranteed to go in

@onready var save_meter = $SaveMeter as ProgressBar

func _ready():
  curr_direction = Direction.LEFT if side == Side.CPU else Direction.RIGHT
  save_meter.value = 100

func handle_ball_collision():
  var ball = game.ball as Ball
  if ball.curr_poss_status == Ball.POSS_STATUS.SHOT_ON_CPU_GOAL or \
    ball.curr_poss_status == Ball.POSS_STATUS.SHOT_ON_PLAYER_GOAL:
    var stamina_dmg = ball.metadata["shot_force"]
    save_meter.value = max(0, save_meter.value - stamina_dmg)
    if save_meter.value > 0:
      super.handle_ball_collision()