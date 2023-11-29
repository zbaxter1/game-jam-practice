extends Node


signal item_selected(item: Item)


func emit_item_selected(item: Item):
	item_selected.emit(item)
