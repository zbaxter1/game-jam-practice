extends CharacterBody2D

@export var run_speed = 120
@export var smoothing = 0.2

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var current_speed = run_speed
	var target_velocity = movement_vector.normalized() * current_speed
	
	velocity = velocity.lerp(target_velocity, smoothing)
	move_and_slide()

	update_animation(movement_vector, current_speed)

func get_movement_vector():
	var x_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x_movement, y_movement)

func attack():
	pass

func update_animation(movement_vector, current_speed):
	if movement_vector != Vector2.ZERO:
		animated_sprite_2d.flip_h = movement_vector.x < 0
		if current_speed == run_speed:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
