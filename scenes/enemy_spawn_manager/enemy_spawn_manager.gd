extends Node2D

@export var enemy_to_spawn: PackedScene
@export var time_between_spawns = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = time_between_spawns
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)

# This function is called every time the timer times out
func _on_spawn_timer_timeout():
	if enemy_to_spawn:
		var enemy_instance = enemy_to_spawn.instantiate()
		# Set the enemy instance's position to a random location
		enemy_instance.global_position = get_random_position()
		add_child(enemy_instance)
	else:
		print("Error: PackedScene not loaded.")

func get_random_position():
	# Example: Return a random position within the screen boundaries
	var viewport_rect = get_viewport_rect()
	var random_x = randf_range(viewport_rect.position.x, viewport_rect.end.x)
	var random_y = randf_range(viewport_rect.position.y, viewport_rect.end.y)
	return Vector2(random_x, random_y)
