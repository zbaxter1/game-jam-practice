extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var move_speed = 25
@export var attack_distance = 30  # Stopping distance for attacking
var alive = true
var player
var can_move = false

@onready var raycasts = %RayCastContainer.get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("spawn_drop")
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	get_player()

# Signal handler for when an animation finishes
func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite_2d.animation == "spawn_drop":
		can_move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player == null:
		animated_sprite_2d.play("idle")
		return
	
	var direction_to_player = player.global_position - global_position
	var distance_to_player = direction_to_player.length()
	
	if can_move and alive:
		if distance_to_player > attack_distance:
			move_towards_player(direction_to_player)
		else:
			attack_player()
		
		# Check for other enemies and adjust movement
		avoid_other_enemies()
	move_and_slide()


func attack_player():
	animated_sprite_2d.play("attack_close")
	velocity = Vector2.ZERO


func move_towards_player(direction_to_player):
	animated_sprite_2d.play("walk")
	velocity = direction_to_player.normalized() * move_speed

	# Flip the sprite based on the direction to the player
	animated_sprite_2d.flip_h = direction_to_player.x < 0


func avoid_other_enemies():
	for raycast in raycasts:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is CharacterBody2D and collider != self:  # Check if it's an enemy and not self
				# Adjust movement to avoid other enemies
				# This can be as simple as reversing or altering the velocity
				velocity = -velocity


func get_player():
	player = get_tree().get_nodes_in_group("player")[0] as Node2D
	
