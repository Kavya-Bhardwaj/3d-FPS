extends Control
## Example: custom OS cursors + tintable crosshair with hit marker.
## Left click = fire (spread + hit marker). Keys 1-4 = crosshair, T = tint, C = toggle crosshair/cursor.

const CROSSHAIRS := ["cross_w2_gap4_len5", "ring_r9_dot1", "chevrons4_s3_d7", "holo_ring_r12_dot"]
const TINTS := [Color.WHITE, Color(0.2, 1.0, 0.3), Color(0.2, 0.9, 1.0), Color(1.0, 0.3, 0.25)]

var crosshair: ReeboCrosshair
var tint_index := 0
var use_crosshair := true


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.08, 0.09, 0.12))
	Cursors.pack_root = "res://assets"
	Cursors.load_manifest()
	Cursors.apply_default_set(32, "outlined")
	crosshair = ReeboCrosshair.new()
	crosshair.pack_root = "res://assets"
	crosshair.follow_mouse = true
	crosshair.hide_os_cursor = false
	crosshair.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(crosshair)
	var label := Label.new()
	label.text = "Click = fire | 1-4 crosshair | T tint | C crosshair on/off"
	label.position = Vector2(16, 16)
	add_child(label)
	_apply_mode()


func _apply_mode() -> void:
	crosshair.visible = use_crosshair
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if use_crosshair else Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and use_crosshair:
		crosshair.spread(1.4)
		crosshair.hit_marker(randf() < 0.2)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1, KEY_2, KEY_3, KEY_4:
				crosshair.set_crosshair(CROSSHAIRS[event.keycode - KEY_1])
			KEY_T:
				tint_index = (tint_index + 1) % TINTS.size()
				crosshair.tint = TINTS[tint_index]
			KEY_C:
				use_crosshair = not use_crosshair
				_apply_mode()
