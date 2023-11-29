extends Resource
class_name ItemResource

enum ItemType {Weapon, Armor}
enum ItemRarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC}

@export var item_type: ItemType
@export var icon_texture: Texture
@export var item_rarity: ItemRarity
