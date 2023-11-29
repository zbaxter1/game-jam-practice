extends CanvasLayer

@export var item_inventory: Array[Item] = []

@onready var grid_container = $MarginContainer/GridContainer

var weapon_slot_scene = preload("res://ui/weapon_slot.tscn")

func _ready():
	for child in grid_container.get_children():
		child.queue_free()

	for item in item_inventory:
		var weapon_slot_instance = weapon_slot_scene.instantiate()
		grid_container.add_child(weapon_slot_instance)
		weapon_slot_instance.set_item(item)
		weapon_slot_instance.selected.connect(on_weapon_slot_selected.bind(item))


func on_weapon_slot_selected(item: Item):
	GameEvents.emit_item_selected(item)
