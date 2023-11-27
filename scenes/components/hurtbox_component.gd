extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


func _ready():
	if !health_component:
		print_debug("no health_component connected")


func damage(damage_stats: Dictionary):
	health_component.damage(damage_stats)


func heal(heal_amount: int):
	health_component.heal(heal_amount)
