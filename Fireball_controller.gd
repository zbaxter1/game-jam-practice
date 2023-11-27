extends Node2D

@export var fireball_ability: PackedScene

var draw_debug: bool = true
var player
var mouse_position
var dexterity = 0.15 # shoot speed

var autofire = false
@onready var shot_delay_timer = %ShotDelayTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player") as Node2D
	shot_delay_timer.wait_time = dexterity
	
	shot_delay_timer.connect("timeout", Callable(self, "fire_shot"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# single clicks
	if Input.is_action_just_pressed("attack") and not autofire:
		fire_shot()
	
	# switch auto-fire setting
	if Input.is_action_just_pressed("autofire"):
		autofire = !autofire
	
	# use auto_fire
	if autofire:
		if shot_delay_timer.is_stopped():
			shot_delay_timer.start()
	
	# click and hold shooting
	else:
		if Input.is_action_pressed("attack") and not autofire:
			if shot_delay_timer.is_stopped():
				shot_delay_timer.start()
		elif not shot_delay_timer.is_stopped():
			shot_delay_timer.stop()


func fire_shot():
	# get mouse position
	var mouse_position : Vector2 = get_global_mouse_position()
	
	# spawn fireball
	var new_fire_ball = fireball_ability.instantiate() as Node2D
	# set the position
	new_fire_ball.global_position = player.global_position
	
	# point the right way
	var direction = (mouse_position - player.global_position).normalized()
	new_fire_ball.direction = direction
	
	# rotate it
	var angle = atan2(direction.y, direction.x)
	new_fire_ball.rotation = angle
	
	# add as a child of a scene
	player.get_parent().add_child(new_fire_ball)
