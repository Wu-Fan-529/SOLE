class_name UITween
extends RefCounted
## UITween.gd — reusable Tween patterns for SOLE's UI.
## Pure static helper. No autoload needed; call as UITween.fade_in(node).

static func fade_in(node: CanvasItem, duration: float = 0.25) -> Tween:
	node.modulate.a = 0.0
	node.visible = true
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	return tween

static func fade_out(node: CanvasItem, duration: float = 0.25, hide_after: bool = true) -> Tween:
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)\
		 .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	if hide_after:
		tween.tween_callback(func(): node.visible = false)
	return tween

static func pop_in(node: Control, duration: float = 0.35) -> Tween:
	node.scale = Vector2.ZERO
	node.visible = true
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2.ONE, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	return tween

static func slide_in(node: Control, offset: Vector2, duration: float = 0.35) -> Tween:
	var target_pos: Vector2 = node.position
	node.position = target_pos + offset
	node.modulate.a = 0.0
	node.visible = true
	var tween: Tween = node.create_tween().set_parallel(true)
	tween.tween_property(node, "position", target_pos, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(node, "modulate:a", 1.0, duration * 0.6)\
		 .set_ease(Tween.EASE_OUT)
	return tween

static func float_loop(node: Node2D, amplitude: float = 4.0, period: float = 1.6) -> Tween:
	var origin_y: float = node.position.y
	var tween: Tween = node.create_tween().set_loops()
	tween.tween_property(node, "position:y", origin_y - amplitude, period * 0.5)\
		 .set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "position:y", origin_y, period * 0.5)\
		 .set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	return tween

static func typewriter(label: RichTextLabel, chars_per_second: float = 25.0) -> Tween:
	var count: int = label.get_total_character_count()
	var duration: float = (count / chars_per_second) if count > 0 else 0.1
	label.visible_ratio = 0.0
	var tween: Tween = label.create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	return tween

static func flash(node: CanvasItem, times: int = 3, interval: float = 0.12) -> Tween:
	var tween: Tween = node.create_tween()
	for i in times:
		tween.tween_property(node, "modulate:a", 0.2, interval)
		tween.tween_property(node, "modulate:a", 1.0, interval)
	return tween
