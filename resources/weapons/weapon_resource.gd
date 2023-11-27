extends Resource
class_name WeaponResource

enum WeaponRarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC}
enum WeaponType {SWORD, KATANA, AXE, DAGGER, BOW, GUN}

@export_group("Weapon Meta-Data")
@export var weapon_id: int
@export var weapon_type: WeaponType
@export var rarity: WeaponRarity
@export var weapon_texture: Texture

@export_group("Weapon Stats")
@export var weapon_damage: int
@export var weapon_cooldown_time: float
@export var weapon_size: float
@export var weapon_pierce: int = 1

@export_group("Ranged Weapon Stats")
@export var weapon_magazine_size: int = 0
@export var weapon_magazine_reload_speed: float = 0
@export var weapon_projectile_speed: float = 0
