extends Camera2D

@export var follow_speed = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_nodes = get_tree().get_nodes_in_group("player")
	
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		var target_position = player.global_position
		global_position = global_position.lerp(target_position, 1 - exp(-delta * 10))
