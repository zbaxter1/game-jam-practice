extends PanelContainer

signal selected

#@export var temp_item: Item

@onready var item_sprite = %ItemSprite
@onready var border_rect = $BorderRect

var slot_empty: bool = true
var current_item: Item = null

var is_weapon_resource: bool = false
var is_armor_resource: bool = false

func _ready():
	item_sprite.texture = null
#	set_item(temp_item)
	pass


func set_item(item: Item):
	current_item = item as Item
	item_sprite.texture = item.item_resource.icon_texture
	slot_empty = false
	
	var item_resource = current_item.item_resource
	if item_resource is WeaponResource:
		print_debug("item resource counts as weapon resource")
		border_rect.color = Color.DARK_RED
		is_weapon_resource = true


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		if current_item:
			var item_id = current_item.item_resource.weapon_id
			print_debug("item id = %s" % item_id)
			selected.emit()
