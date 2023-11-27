extends CharacterBody2D

@export var max_health = 5
@export var move_speed = randi_range(20, 25)
@export var close_attack_distance = 20  # Stopping distance for attacking
@export var ranged_attack_distance = 35
@export var range_attack: PackedScene

var alive = true
var current_health
var player
var can_move = false
var spawning = false
var is_attacking = false
var waiting_to_attack = false
var attack_count = 0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var ranged_attack_spawn_position = %Ranged_Attack_Spawn_Position
@onready var ranged_attack_cool_down = $Ranged_Attack_CoolDown
@onready var ranged_attack_delay = $Ranged_Attack_Delay
@onready var raycasts = %RayCastContainer.get_children()
@onready var health_component = $HealthComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	spawning = true
	animated_sprite_2d.play("spawn_drop")
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	get_player()
	
	area_2d.area_entered.connect(on_area_entered)
	# make sure to start with full health
	current_health = max_health
	health_component.died.connect(on_died)

# Signal handler for when an animation finishes
func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite_2d.animation == "spawn_drop":
		can_move = true
		spawning = false
	elif animated_sprite_2d.animation == "die":
		call_deferred("queue_free")
	elif animated_sprite_2d.animation == "attack_ranged":
		waiting_to_attack = true
	elif animated_sprite_2d.animation == "attack_close":
		is_attacking = false
	elif animated_sprite_2d.animation == "hit":
		can_move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player == null:
		animated_sprite_2d.play("idle")
		return
	
	if can_move and alive:
		var direction_to_player = player.global_position - global_position
		var distance_to_player = direction_to_player.length()
		
		if distance_to_player < ranged_attack_distance and not is_attacking and attack_count % 2 == 0:
			attack_player_ranged(direction_to_player.normalized())
			#print("atack ranged")
		elif distance_to_player < close_attack_distance and not is_attacking:
			#print("atack_close")
			attack_player_close(direction_to_player)
		elif not is_attacking and player:
			move_towards_player(direction_to_player)
		elif waiting_to_attack:
			animated_sprite_2d.play("idle")
	elif not can_move and not spawning:
		velocity = Vector2.ZERO
	move_and_slide()


func attack_player_close(direction_to_player):
	attack_count += 1
	is_attacking = true
	animated_sprite_2d.play("attack_close")
	velocity = Vector2.ZERO
	animated_sprite_2d.flip_h = direction_to_player.x < 0
	await ranged_attack_cool_down.timeout
	is_attacking = false


func attack_player_ranged(direction_to_player):
	attack_count += 1
	is_attacking = true
	animated_sprite_2d.play("attack_ranged")
	velocity = Vector2.ZERO
	animated_sprite_2d.flip_h = direction_to_player.x < 0
	
	if is_attacking:
		await ranged_attack_delay.timeout 
		# handle ranged attack
		var new_attack = range_attack.instantiate() as Node2D
		new_attack.position = Vector2.ZERO
		#new_attack.direction = direction_to_player
		var angle = atan2(direction_to_player.y, direction_to_player.x)
		new_attack.rotate(angle)
		#ranged_attack_spawn_position.rotation = angle
		
		# add as a child
		ranged_attack_spawn_position.add_child(new_attack)
	waiting_to_attack = true
	await ranged_attack_cool_down.timeout
	waiting_to_attack = false
	is_attacking = false


func move_towards_player(direction_to_player):
	animated_sprite_2d.play("walk")
	velocity = direction_to_player.normalized() * move_speed

	# Flip the sprite based on the direction to the player
	animated_sprite_2d.flip_h = direction_to_player.x < 0


func die():
	alive = false
	area_2d.queue_free()
	collision_shape_2d.queue_free()
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")
	# gets removed from _on_AnimatedSprite2D_animation_finished() method


func get_player():
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

func on_area_entered(other_area: Area2D):
	# projectile collision check
	if other_area.get_collision_layer_value(5):
		var projectile = other_area.get_parent() as Projectile
		take_damage(projectile.damage)
		#print(current_health)


func take_damage(damage_amount):
	if current_health > 1:
		can_move = false
		animated_sprite_2d.play("hit")
		current_health -= damage_amount
		velocity = Vector2.ZERO
	else:
		die()
	


func on_died():
	queue_free()
