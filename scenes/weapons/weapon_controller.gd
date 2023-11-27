extends Node

@onready var weapon_cooldown_timer = $WeaponCooldownTimer

var current_weapon: PackedScene = null
var weapon_cooldown_time: float
var weapon_scene_preload = preload("res://scenes/weapons/dagger_common.tscn")

func _ready():
	set_weapon(weapon_scene_preload)


func set_weapon(weapon_scene: PackedScene):
	var weapon_scene_instance = weapon_scene.instantiate() as WeaponScene
	if weapon_scene_instance is WeaponScene:
		current_weapon = weapon_scene
		
	weapon_cooldown_time = weapon_scene_instance.get_cooldown_time()
	weapon_cooldown_timer.wait_time = weapon_cooldown_time


func remove_weapon():
	current_weapon = null


func get_current_weapon() -> PackedScene:
	return current_weapon


func use_weapon(player: CharacterBody2D, mouse_position: Vector2):
	if !current_weapon:
		return
	
	if !weapon_cooldown_timer.is_stopped():
		return
	
	var current_weapon_instance = current_weapon.instantiate()
	var node_location = player.get_sprite()
	node_location.add_child(current_weapon_instance)
	current_weapon_instance.attack(player, mouse_position)
	weapon_cooldown_timer.start()
