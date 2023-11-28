extends Node2D
class_name WeaponScene

@export var weapon_resource: WeaponResource

# how far to spawn the weapon away from the player's weapon origin point
var extension_range = 16


func _ready():
	if !weapon_resource:
		print_debug("no weapon_resource connected")
	
	scale *= weapon_resource.weapon_size


func attack(player: CharacterBody2D, mouse_position: Vector2):
	if !weapon_resource:
		return
	
	# Getting weapon position and angle
	var player_position = player.get_weapon_origin() as Vector2
	var weapon_direction = player_position.direction_to(mouse_position)
	var weapon_position = player_position + (weapon_direction * extension_range)
	var weapon_angle = weapon_direction.angle()
	global_position = weapon_position
	rotation = weapon_angle + (PI/2)
	
	# Getting weapon animation and setting the speed
	var animation = $AnimationPlayer.get_animation("attack")
	var animation_length = animation.length
	var cooldown_time = weapon_resource.weapon_cooldown_time
	var playback_speed = 1
	if cooldown_time < animation_length:
		playback_speed = animation_length / cooldown_time
		
	$AnimationPlayer.play("attack", -1, playback_speed)


func get_cooldown_time() -> float:
	if !weapon_resource:
		return -1
		
	return weapon_resource.weapon_cooldown_time


func get_damage_stats() -> Dictionary:
	var damage_stats = {
		"damage": weapon_resource.weapon_damage,
		"damage_element": weapon_resource.weapon_damage_element,
		"damage_type": weapon_resource.weapon_damage_type
	}
	return damage_stats
