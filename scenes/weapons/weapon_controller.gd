extends Node

@onready var weapon_cooldown_timer = $WeaponCooldownTimer

var weapon_cooldown_time: float
var temp_item_resource: Item = preload("res://resources/items/weapons/weapon_resources/sword/sword_item.tres")

var current_item: Item = null
var current_weapon_resource: WeaponResource = null
var current_weapon_controller: PackedScene = null

func _ready():
	set_weapon(temp_item_resource)
	GameEvents.item_selected.connect(set_weapon)


func set_weapon(weapon_item: Item):
	current_item = weapon_item
	current_weapon_resource = weapon_item.item_resource as WeaponResource
	current_weapon_controller = weapon_item.item_controller
	
	weapon_cooldown_time = current_weapon_resource.weapon_cooldown_time
	weapon_cooldown_timer.wait_time = weapon_cooldown_time


func remove_weapon():
	current_item = null
	current_weapon_resource = null
	current_weapon_controller = null


func get_current_item() -> Item:
	return current_item


func use_weapon():
	if !current_item:
		return
	
	if !weapon_cooldown_timer.is_stopped():
		return
	
	var weapon_controller_instance = current_weapon_controller.instantiate()
	var player = get_tree().get_first_node_in_group("player")
	var node_location = player.get_sprite()
	node_location.add_child(weapon_controller_instance)
	weapon_controller_instance.attack(current_weapon_resource)
	weapon_cooldown_timer.start()
