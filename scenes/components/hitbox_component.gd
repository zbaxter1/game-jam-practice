extends Area2D
class_name HitboxComponent


func _on_area_entered(area):
	if !area is HurtboxComponent:
		return
	
	# get the damage stats from the parent node
	# must return as a dictionary with keys of: damage, damage_element, damage_type
	var damage_stats = get_parent().get_damage_stats()
	area.damage(damage_stats)
