class_name Goalkeeper
extends FieldPlayer

# Goalkeeper can save the ball if their "save meter" is still full
# Ever save depletes the save meter, and once empty, the next shot is guaranteed to go in

@onready var save_meter = $SaveMeter as ProgressBar
@onready var animated_sprite = $AnimatedSprite2D as AnimatedSprite2D

var prev_anim_state = ''
var num_frames_in_anim_state = 0
var stam_recovered_per_second = 1

func _ready():
  curr_direction = Direction.LEFT if side == Side.CPU else Direction.RIGHT
  save_meter.value = 100
  if side == Side.CPU:
    animated_sprite.sprite_frames = load("res://animations/cpu-field-player.tres")
    animated_sprite.play("idle")
  else:
    animated_sprite.sprite_frames = load("res://animations/player-field-player.tres")
    animated_sprite.play("idle")

  # Stamina recovery
  var stam_recovery_timer = Timer.new()
  stam_recovery_timer.autostart = true
  stam_recovery_timer.one_shot = false
  stam_recovery_timer.wait_time = 1
  var on_timeout = Callable(self, "_recover_stamina")
  stam_recovery_timer.timeout.connect(on_timeout)
  add_child(stam_recovery_timer)

func _recover_stamina():
  save_meter.value += stam_recovered_per_second

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
    transition_to_anim('idle')
  else:
    is_moving_to_position = true
    context_map.target_position = dest_position
    var dir = context_map.best_dir
    if side == Side.CPU:
      sprite.flip_h = true
    elif side == Side.PLAYER:
      sprite.flip_h = false
    transition_to_anim('run')
    var desired_velocity = dir * FieldPlayer.SPEED
    var steering_force = desired_velocity - linear_velocity
    linear_velocity = linear_velocity + (steering_force * 2 * 0.0167)
  
func transition_to_anim(new_anim_state):
  # If this is a switch up, don't immediately change to new animation (otherwise we get weird flashing)
  if prev_anim_state != new_anim_state:
    prev_anim_state = new_anim_state
    num_frames_in_anim_state = 1
  else:
    if num_frames_in_anim_state >= 20:
      sprite.play(new_anim_state)
    num_frames_in_anim_state += 1

func get_point_to_defend(enemy_field_player: FieldPlayer):
  var self_goal = game.cpu_goal if side == Side.CPU else game.player_goal
  var start_x = 475 if side == Side.CPU else -475
  var line_start = Vector2(start_x, -324)
  var line_end = Vector2(start_x, 324)
  return Geometry2D.segment_intersects_segment(enemy_field_player.global_position, self_goal.global_position, line_start, line_end)