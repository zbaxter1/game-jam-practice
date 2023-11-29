extends Node


signal item_selected(item: Item)


var mouse_over_ui: bool = false
var mouse_overlapping_ui_count: int = 0


func emit_item_selected(item: Item):
	item_selected.emit(item)


func mouse_entered_ui():
	mouse_overlapping_ui_count += 1
	if mouse_overlapping_ui_count > 0:
		mouse_over_ui = true


func mouse_exited_ui():
	mouse_overlapping_ui_count -= 1
	if mouse_overlapping_ui_count <= 0:
		mouse_over_ui = false
