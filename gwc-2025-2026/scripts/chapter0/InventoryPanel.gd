extends Control
## Minimal inventory data layer + slide-in reveal.

var items: Array[String] = []
@onready var label: Label = $Label

func add_item(item_id: String) -> void:
	if item_id in items:
		return
	items.append(item_id)
	_refresh()
	if items.size() == 1:
		UITween.slide_in(self, Vector2(40, 0), 0.35)

func has_item(item_id: String) -> bool:
	return item_id in items

func _refresh() -> void:
	if label:
		label.text = "Inventory: " + ", ".join(items)
