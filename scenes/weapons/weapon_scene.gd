extends Node2D
class_name WeaponScene

@onready var collision_shape_2d = %CollisionShape2D

var current_weapon_resource: WeaponResource

# how far to spawn the weapon away from the player's weapon origin point
var extension_range = 16


func _process(delta):
	set_attack_position()


func set_attack_position():
	# Getting weapon position and angle relative to the player
	var player = get_tree().get_first_node_in_group("player")
	var player_position = player.get_weapon_origin() as Vector2
	var weapon_direction = player_position.direction_to(get_global_mouse_position())
	var weapon_position = player_position + (weapon_direction * extension_range)
	var weapon_angle = weapon_direction.angle()
	global_position = weapon_position
	rotation = weapon_angle + (PI/2)


func attack(weapon_resource: WeaponResource):
	current_weapon_resource = weapon_resource
	
	# set the weapon size and hitbox according to the weapon_size property of the weapon resource
	scale *= current_weapon_resource.weapon_size
	
	# get where the attack needs to spawn
	set_attack_position()
	
	# Getting weapon animation and setting the speed
	var animation = $AnimationPlayer.get_animation("attack")
	var animation_length = animation.length
	var cooldown_time = current_weapon_resource.weapon_cooldown_time
	var playback_speed = 1
	if cooldown_time < animation_length:
		playback_speed = animation_length / cooldown_time
		
	$AnimationPlayer.play("attack", -1, playback_speed)


func get_cooldown_time() -> float:
	if !current_weapon_resource:
		return -1
		
	return current_weapon_resource.weapon_cooldown_time


func get_damage_stats() -> Dictionary:
	var damage_stats = {
		"damage": current_weapon_resource.weapon_damage,
		"damage_element": current_weapon_resource.weapon_damage_element,
		"damage_type": current_weapon_resource.weapon_damage_type
	}
	return damage_stats
