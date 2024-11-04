class_name ContextMap
extends Node2D

var raycast_list = []
var directions = [
	Vector2(0, -1),
	Vector2(0.5, -1),
	Vector2(1, -1),
	Vector2(2, -0.5),
	Vector2(1, 0),
	Vector2(1, 0.5),
	Vector2(1, 1),
	Vector2(0.5, 1),
	Vector2(0, 1),
	Vector2(-0.5, 1),
	Vector2(-1, 1),
	Vector2(-1, 0.5),
	Vector2(-1, 0),
	Vector2(-1, -0.5),
	Vector2(-1, -1),
	Vector2(-0.5, -1)
]
var target_position
var best_dir: Vector2 = Vector2.ZERO

func _ready():
	for c in get_children():
		raycast_list.append(c)

func update_ray_collision_based_on_side():
	var parent_field_player = get_parent() as FieldPlayer
	if parent_field_player.side == FieldPlayer.Side.PLAYER:
		for ray in raycast_list:
			ray.set_collision_mask_value(1, false)
			ray.set_collision_mask_value(2, true)
	else:
		for ray in raycast_list:
			ray.set_collision_mask_value(1, true)
			ray.set_collision_mask_value(2, false)


func _physics_process(_delta):
	if target_position != null:
		var danger_map = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		for i in range(0, raycast_list.size()):
			var ray = raycast_list[i] as RayCast2D
			if ray.is_colliding():
				danger_map[i] = 7
				danger_map[(i + 2) % danger_map.size()] = 2
				danger_map[(i + 1) % danger_map.size()] = 5
				danger_map[(i - 1) % danger_map.size()] = 5
				danger_map[(i - 2) % danger_map.size()] = 2
			else:
				if danger_map[i] == 0:
					danger_map[i] = 0

		var context_map = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		var highest_val = -INF
		var curr_best_dir = Vector2.ZERO
		for i in range(0, directions.size()):
			var dir_vector = directions[i] as Vector2
			var vector_to_target = (target_position - global_position).normalized()
			var dot_product = dir_vector.dot(vector_to_target)
			context_map[i] = dot_product - danger_map[i]
			if context_map[i] > highest_val:
				curr_best_dir = directions[i]
				highest_val = context_map[i]
		best_dir = curr_best_dir
