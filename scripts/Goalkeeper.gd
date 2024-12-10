class_name Goalkeeper
extends FieldPlayer

# Goalkeeper can save the ball if their "save meter" is still full
# Ever save depletes the save meter, and once empty, the next shot is guaranteed to go in

@onready var save_meter = $SaveMeter as ProgressBar
@onready var animated_sprite = $AnimatedSprite2D as AnimatedSprite2D

func _ready():
  curr_direction = Direction.LEFT if side == Side.CPU else Direction.RIGHT
  save_meter.value = 100
  if side == Side.CPU:
    animated_sprite.sprite_frames = load("res://animations/cpu-field-player.tres")
    animated_sprite.play("idle")
  else:
    animated_sprite.sprite_frames = load("res://animations/player-field-player.tres")
    animated_sprite.play("idle")

func handle_ball_collision():
  var ball = game.ball as Ball
  if ball.curr_poss_status == Ball.POSS_STATUS.SHOT_ON_CPU_GOAL or \
	ball.curr_poss_status == Ball.POSS_STATUS.SHOT_ON_PLAYER_GOAL:
    var stamina_dmg = ball.metadata["shot_force"]
    save_meter.value = max(0, save_meter.value - stamina_dmg)
    if save_meter.value > 0:
      # random ricochet
      game.camera.apply_shake()
      var x_pos = 300 if side == Side.CPU else -300
      var y_pos = randi_range(-300, 300)
      var dir = Vector2(x_pos, y_pos) - global_position
      ball.linear_velocity = dir.normalized() * FieldPlayer.SHOOT_SPEED * 0.3
      ball.curr_poss_status = Ball.POSS_STATUS.LOOSE
	
func _physics_process(_delta):
  # var closest_enemy = get_closest_enemy_field_player()
  var enemy_with_ball = game.get_ball_handler()
  if enemy_with_ball != null and enemy_with_ball.side != side:
    var point_to_defend = get_point_to_defend(enemy_with_ball)
    if point_to_defend != null:
      move_to_position(point_to_defend, 2)
  else:
    linear_velocity = Vector2.ZERO


func move_to_position(dest_position: Vector2, is_at_pos_threshold):
  if is_going_for_steal:
    return
  if global_position.distance_to(dest_position) <= is_at_pos_threshold or is_stunned:
    is_moving_to_position = false
    linear_velocity = Vector2.ZERO
  else:
    is_moving_to_position = true
    context_map.target_position = dest_position
    var dir = context_map.best_dir
    if dir.x <= 0.001:
      sprite.flip_h = true
    else:
      sprite.flip_h = false
    var desired_velocity = dir * FieldPlayer.SPEED
    var steering_force = desired_velocity - linear_velocity
    linear_velocity = linear_velocity + (steering_force * 2 * 0.0167)

func get_point_to_defend(enemy_field_player: FieldPlayer):
  var self_goal = game.cpu_goal if side == Side.CPU else game.player_goal
  var start_x = 475 if side == Side.CPU else -475
  var line_start = Vector2(start_x, -324)
  var line_end = Vector2(start_x, 324)
  return Geometry2D.segment_intersects_segment(enemy_field_player.global_position, self_goal.global_position, line_start, line_end)