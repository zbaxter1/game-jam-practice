extends Resource
class_name WeaponResource

const WeaponEnums = preload("res://scenes/enums/WeaponEnums.gd")
const DamageEnums = preload("res://scenes/enums/DamageEnums.gd")

@export_group("Weapon Meta-Data")
@export var weapon_id: int
@export var weapon_type: WeaponEnums.WeaponType
@export var rarity: WeaponEnums.WeaponRarity
@export var weapon_texture: Texture

@export_group("Weapon Stats")
@export var weapon_damage: int
@export var weapon_damage_element: DamageEnums.DamageElement = DamageEnums.DamageElement.PHYSICAL
@export var weapon_damage_type: DamageEnums.DamageType = DamageEnums.DamageType.SLASH
@export var weapon_cooldown_time: float
@export var weapon_size: float
@export var weapon_pierce: int = 1

@export_group("Ranged Weapon Stats")
@export var weapon_magazine_size: int = 0
@export var weapon_magazine_reload_speed: float = 0
@export var weapon_projectile_speed: float = 0
