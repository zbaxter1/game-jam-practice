extends CharacterBody2D

signal dash_used
signal dash_at_max_charges
signal dash_set_charges(charges: int)

@export var run_speed: int = 120
@export var smoothing: float = 0.2
@export_group("Dash")
@export var dash_multiplier: int = 7
@export var dash_max_charges: int = 3
@export var dash_charge_cooldown: float = 1
var dash_current_charges: int = dash_max_charges

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer = $DashCooldownTimer

var isDashing: bool = false
#test
# Called when the node enters the scene tree for the first time.
func _ready():
	dash_cooldown_timer.wait_time = dash_charge_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isDashing:
		var movement_vector = get_movement_vector()
		var current_speed = run_speed
		var target_velocity = movement_vector.normalized() * current_speed
		
		velocity = velocity.lerp(target_velocity, smoothing)
		update_animation(movement_vector, current_speed)
		
	move_and_slide()


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


func _input(event):
	if Input.is_action_just_pressed("dash"):
		dash()

func dash():
	if isDashing:
		return
		
	if dash_current_charges <= 0:
		return
		
	dash_current_charges -= 1
	if dash_cooldown_timer.is_stopped():
		dash_cooldown_timer.start()
		dash_used.emit()
		
	print_debug("dashing")
	isDashing = true
	var movement_vector = get_movement_vector()
	velocity = movement_vector * run_speed * dash_multiplier
	collision_mask -= 4
	dash_set_charges.emit(dash_current_charges)
	dash_timer.start()
	await dash_timer.timeout
	isDashing = false
	collision_mask += 4
	velocity = movement_vector * run_speed


func _on_dash_cooldown_timer_timeout():
	dash_current_charges += 1
	if dash_current_charges >= dash_max_charges:
		dash_at_max_charges.emit()
		dash_cooldown_timer.stop()
		
	print_debug("passing charges = %d" % dash_current_charges)
	dash_set_charges.emit(dash_current_charges)
