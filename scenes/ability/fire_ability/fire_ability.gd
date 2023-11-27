extends Node2D
class_name Projectile
@onready var fireball_lifetime = %fireball_lifetime

@onready var area_2d = $Area2D
@export var swirl_effect : PackedScene

@export var damage = 1
var speed = 300
var direction
var mouse_position

func _ready():
	fireball_lifetime.connect("timeout", Callable(self, "expire"))
	area_2d.area_entered.connect(_on_area_2d_area_entered)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _start():
	# get mouse position
	mouse_position = get_viewport().get_mouse_position()

	# Calculate the angle for the direction
	var angle = atan2(direction.y, direction.x) + PI / 2

	# Set the node's rotation
	rotation = angle

func _process(delta):
	# move the fireball
	global_position += direction * speed * delta

# make sure it is removed at some point
func expire():
	queue_free()


func _on_area_2d_area_entered(area):
	visible = false
	var swirl = swirl_effect.instantiate() as Node2D
	swirl.global_position = global_position
	get_tree().root.add_child(swirl)
	queue_free()
	
